import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_receipt.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementitem.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final groupProvider = ChangeNotifierProvider<GroupViewModel>((ref) =>
    GroupViewModel());

class GroupViewModel extends ChangeNotifier {
  ServiceUser userData = ServiceUser();
  Group myGroup = Group();
  List<ServiceUser> serviceUsers = <ServiceUser>[];
  List<Settlement> settlementInGroup = <Settlement>[];
  // List<MergedSettlement> mergedSettlementInGroup = <MergedSettlement> [];

  GroupViewModel();

  Future<void> settingGroupViewModel(ServiceUser me, String groupId) async {
    userData = me;
    settlementInGroup = []; serviceUsers = [];
    myGroup = await Group().getGroupByGroupId(groupId);
    for (var userid in myGroup.serviceUsers) {
      serviceUsers.add(await ServiceUser().getUserByUserId(userid));
    }
    for (var stmid in myGroup.settlements) {
      settlementInGroup
          .add(await Settlement().getSettlementBySettlementId(stmid));
    }
    notifyListeners();
    /*myGroup.mergedSettlements.forEach((stmid) async {
      MergedSettlement stm = await MergedSettlement().getSettlementBySettlementId(stmid);
      mergedSettlementInGroup.add(stm);
      //log("그냥 정산: ${stm.settlementName}");
      notifyListeners();
    });
     */
    return;
  }

  void updateSettlement(String settlementId) async {
    Settlement data =
        await Settlement().getSettlementBySettlementId(settlementId);
    settlementInGroup.add(data);
    notifyListeners();
  }

  void addByDirect(String userName) {
    ServiceUser user = ServiceUser();
    user.name = userName;
    user.createUser();
    serviceUsers.add(user);
    notifyListeners();
  }

  void addByKakaoFriends() async {
    var params = PickerFriendRequestParams(
      title: 'Multi Picker',
      enableSearch: true,
      showMyProfile: false,
      showFavorite: true,
      showPickedFriend: true,
      maxPickableCount: null,
      minPickableCount: null,
      enableBackButton: true,
    );

    SelectedUsers users =
        await PickerApi.instance.selectFriends(params: params);

    for (int i = 0; i < users.totalCount; i++) {
      SelectedUser kuser = users.users![i];
      ServiceUser user = ServiceUser();
      user.name = kuser.profileNickname;
      user.kakaoId = kuser.id;
      user.createUser();
      serviceUsers.add(user);
    }
    notifyListeners();
  }

  void deleteUser(String userId) {
    serviceUsers.removeWhere((user) => user.serviceUserId == userId);
    notifyListeners();
  }

  void updateGroup(String groupId, String name) {
    myGroup.groupName = name;
    FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
    notifyListeners();
  }

  void updateUserName(String userId, String newName) async {

    ServiceUser user = await ServiceUser().getUserByUserId(userId);

    if (user.kakaoId == null) {
      user.name = newName;
      FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
      //user.UpdateUser();
    } else {
      print("카카오톡으로 추가한 유저의 이름은 변경할 수 없습니다.");
    }

  }

  bool checkMaster(int index) {
    if (settlementInGroup[index].masterUserId != userData.serviceUserId) {
      return false;
    }
    return true;
  }

  bool ifExistUnChecked(int index) {
    for (var entry in settlementInGroup[index].checkSent.entries) {
      if (entry.value == 1 || entry.value == 2) {
        return true;
      }
    }
    return false;
  }

  bool isAccountSame(String prevAccount, int index) {
    if (prevAccount != settlementInGroup[index].accountInfo) {
      return false;
    }
    return true;
  }

  void unifyAccountInfo(int chosenAccount, List<int> indexes) async {
    indexes.forEach((index) async {
      settlementInGroup[index].accountInfo =
          userData.accountInfo[chosenAccount];
      FireService().updateDoc(
          "settlementlist",
          settlementInGroup[index].settlementId!,
          settlementInGroup[index].toJson());
    });
  }

  int checkMergeCondition(List<int> indexes) {
    String prevAccount = settlementInGroup[0].accountInfo!;
    for (var index in indexes) {
      if (!checkMaster(index)) {
        print("정산자가 일치하지 않습니다.");
        return 1;
      }
      if (!ifExistUnChecked(index)) {
        print("아직 처리되지 않은 송금을 확인해주세요.");
        return 2;
      }
    }

    return 0;
  }

  //앞의 병합 조건들을 모두 만족했다는 전제 하에 해당 메소드 호출하도록
  void mergeSettlements(List<int> indexes, String newName) async {
    if (indexes.length > 10) {
      print("최대 10개까지만 담을 수 있습니다.");
      return;
    }

    Map<String, SettlementPaper> newMergedPapers = <String, SettlementPaper>{};
    //value int값: settlement index 값
    double totalPrice = 0;
    Settlement newMergedSettlement = Settlement();
    newMergedSettlement.settlementName = newName;
    newMergedSettlement.groupId = myGroup.groupId;
    newMergedSettlement.accountInfo = settlementInGroup[indexes[0]].accountInfo;
    newMergedSettlement.masterUserId =
        settlementInGroup[indexes[0]].masterUserId;
    newMergedSettlement.isMerged = true;

    await Future.forEach(serviceUsers, (user) async {
      SettlementPaper newMergedPaper = SettlementPaper();
      newMergedPaper.serviceUserId = user.serviceUserId;
      newMergedPaper.accountInfo = newMergedSettlement.accountInfo;
      newMergedPaper.settlementId = newMergedSettlement.settlementId;
      newMergedPaper.userName = user.name;
      newMergedPaper.isMerged = true;
      newMergedSettlement.settlementPapers[user.serviceUserId!] =
          newMergedPaper.settlementPaperId!;
      newMergedPapers[user.serviceUserId!] = newMergedPaper;
      if (newMergedSettlement.masterUserId != user.serviceUserId!) {
        newMergedSettlement.checkSent[user.serviceUserId!] = 0;
      }
      user.settlements.add(newMergedSettlement.settlementId!);
      user.settlementPapers.add(newMergedPaper.settlementPaperId!);
    });

    //병합할 정산들에 대한 병합 과정 본격적 진행
    await Future.forEach(indexes, (index) async {
      newMergedSettlement.receipts.addAll(settlementInGroup[index].receipts);

      settlementInGroup[index].receipts.forEach((rcpid) async {
        Receipt rcp = await Receipt().getReceiptByReceiptId(rcpid);
        rcp.settlementId = newMergedSettlement.settlementId;
        FireService().updateDoc("receiptlist", rcpid!, rcp.toJson());
      });

      await Future.forEach(serviceUsers, (user) async {
        //해당 정산에 참여하지 않는 유저는 skip
        if (settlementInGroup[index].settlementPapers[user.serviceUserId] !=
            null) {
          SettlementPaper paper = await SettlementPaper()
              .getSettlementPaperByPaperId(settlementInGroup[index]
                  .settlementPapers[user.serviceUserId]!);

          //이미 송금을 완료한 정산들에 대한 처리 -> sentSettlementItems에 저장
          if (settlementInGroup[index].checkSent[user.serviceUserId!] == 3) {

            //개별 정산서에 병합 정산 자체의 이름은 포함되지 않음, 병합 정산 안에 존재하는 정산들의 이름들만 표기
            if(settlementInGroup[index].isMerged == false) {
              SettlementItem title = SettlementItem();
              title.menuName = settlementInGroup[index].settlementName;
              title.receiptItemId = "dummy"; //더미 구분 용도, 메뉴 이름: 정산 이름으로 대체
              newMergedPapers[user.serviceUserId!]
                  ?.sentSettlementItems
                  .add(title.settlementItemId!);
              title.createSettlementItem();
            }

            await Future.forEach(paper.sentSettlementItems, (itemid) async {
              newMergedPapers[user.serviceUserId!]!
                  .sentSettlementItems
                  .add(itemid);
              print("유저 ${user.name}의 정산항목: ${itemid} ");
            });
            if (newMergedPapers[user.serviceUserId!]!.discountedTotalPrice ==
                0) {
              newMergedPapers[user.serviceUserId!]!.discountedTotalPrice =
                  paper.discountedTotalPrice!;
            } else {
              newMergedPapers[user.serviceUserId!]!.discountedTotalPrice =
                  newMergedPapers[user.serviceUserId!]!.discountedTotalPrice! +
                      paper.discountedTotalPrice!;
            }
            print(
                "유저 ${user.name}의 정산서 할인된 합계 금액: ${newMergedPapers[user.serviceUserId!]!.discountedTotalPrice} ");
          } //그외 케이스들...
          else {
            if (settlementInGroup[index].checkSent[user.serviceUserId!] == 0) {
              newMergedSettlement.checkSent[user.serviceUserId!] = 0;
            }
            //개별 정산서에 병합 정산 자체의 이름은 포함되지 않음, 병합 정산 안에 존재하는 정산들의 이름들만 표기
            if(settlementInGroup[index].isMerged == false) {
              SettlementItem title = SettlementItem();
              title.menuName = settlementInGroup[index].settlementName;
              title.receiptItemId = "dummy"; //더미 구분 용도, 메뉴 이름: 정산 이름으로 대체
              newMergedPapers[user.serviceUserId!]
                  ?.settlementItems
                  .add(title.settlementItemId!);
              title.createSettlementItem();
            }
            
            await Future.forEach(paper.sentSettlementItems, (itemid) async {
              print("유저 ${user.name}의 정산항목: ${itemid} ");
              newMergedPapers[user.serviceUserId!]!.settlementItems.add(itemid);
            });
          }

          if (newMergedPapers[user.serviceUserId!]!.totalPrice == 0) {
            newMergedPapers[user.serviceUserId!]!.totalPrice =
                paper.totalPrice!;
          } else {
            newMergedPapers[user.serviceUserId!]!.totalPrice =
                newMergedPapers[user.serviceUserId!]!.totalPrice! +
                    paper.totalPrice!;
          }
          print(
              "유저 ${user.name}의 정산서 합계 금액: ${newMergedPapers[user.serviceUserId!]!.totalPrice} ");

          user.settlements.remove(settlementInGroup[index].settlementId!);
          FireService().deleteDoc("settlementpaperlist",
              settlementInGroup[index].settlementPapers[user.serviceUserId!]!);
        }
      });

      if (totalPrice == 0) {
        totalPrice = settlementInGroup[index].totalPrice;
      } else {
        totalPrice += settlementInGroup[index].totalPrice;
      }
      userData.settlements.remove(settlementInGroup[index].settlementId!);
      myGroup.settlements.remove(settlementInGroup[index].settlementId!);
      FireService()
          .deleteDoc("settlementlist", settlementInGroup[index].settlementId!);
    });

    await Future.forEach(newMergedPapers.entries, (entry) async {
      entry.value.createSettlementPaper();
    });

    await Future.forEach(serviceUsers, (user) async {
      FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
    });

    newMergedSettlement.totalPrice = totalPrice;
    myGroup.settlements.add(newMergedSettlement.settlementId!);
    FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
    newMergedSettlement.time = Timestamp.now();
    newMergedSettlement.createSettlement();
  }
}
