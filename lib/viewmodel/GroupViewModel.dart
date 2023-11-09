import 'dart:developer';
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

final groupProvider = ChangeNotifierProvider<GroupViewModel>(
        (ref) => GroupViewModel("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb","1800d31d-6d49-4672-8ca7-d094b1a2e1d5"));

class GroupViewModel extends ChangeNotifier {

  ServiceUser userData = ServiceUser();
  Group myGroup = Group();
  List<ServiceUser> serviceUsers = <ServiceUser> [];
  List<Settlement> settlementInGroup = <Settlement> [];

  GroupViewModel(String userId, String groupId) {
    serviceUsers = []; settlementInGroup = [];
    settingGroupViewModel(userId, groupId);
  }

  Future<void> settingGroupViewModel(String userId, String groupId) async {
    serviceUsers = []; settlementInGroup = [];
    userData = await ServiceUser().getUserByUserId(userId);
    myGroup = await Group().getGroupByGroupId(groupId);
    notifyListeners();


    myGroup.serviceUsers.forEach((userid) async {
      serviceUsers.add(await ServiceUser().getUserByUserId(userid));
      notifyListeners();
    });

    myGroup.settlements.forEach((stmid) async {
      Settlement stm = await Settlement().getSettlementBySettlementId(stmid);
      settlementInGroup.add(stm);
        //log("그냥 정산: ${stm.settlementName}");
      notifyListeners();
    });
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
    Settlement data = await Settlement().getSettlementBySettlementId(settlementId);
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
    
    SelectedUsers users = await PickerApi.instance.selectFriends(params: params);

    for(int i = 0; i < users.totalCount; i++){
      SelectedUser kuser = users.users![i];
      ServiceUser user = ServiceUser();
      user.name = kuser.profileNickname;
      user.kakaoId =  kuser.id;
      user.createUser();
      serviceUsers.add(user);
    }
    notifyListeners();
  }

  void deleteUser(String userId){
    serviceUsers.removeWhere((user) => user.serviceUserId == userId);
    notifyListeners();
  }

  void updateGroup(String GroupId, String name){
    if(name != null ) {
      myGroup.groupName = name;
    }
    FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
    notifyListeners();
  }

  void updateUserName(String userId, String newName) async {
    ServiceUser user = await ServiceUser().getUserByUserId(userId);

    if(user.kakaoId == null) {
      user.name = newName;
      FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
      //user.UpdateUser();
    }
    else {
      print("카카오톡으로 추가한 유저의 이름은 변경할 수 없습니다.");
    }
    notifyListeners();
  }

  bool checkMaster(int index) {
    if(settlementInGroup[index].masterUserId != userData.serviceUserId) {
      return false;
    }
    return true;
  }

  bool ifExistUnChecked(int index) {

    for(var entry in settlementInGroup[index].checkSent.entries) {
      if(entry.value == 1) {
        return true;
      }
    }
    return false;
  }

  bool isAccountSame(String prevAccount, int index) {

    if(prevAccount != settlementInGroup[index].accountInfo) {
      return false;
    }
    return true;
  }

  void unifyAccountInfo(int chosenAccount, List<int> indexes) async {
    indexes.forEach((index) async {
      settlementInGroup[index].accountInfo = userData.accountInfo[chosenAccount];
      FireService().updateDoc("settlementlist", settlementInGroup[index].settlementId!, settlementInGroup[index].toJson());
    });
  }

  int checkMergeCondition(List<int> indexes) {

    String prevAccount = settlementInGroup[0].accountInfo!;
    for(var index in indexes) {
      if(!checkMaster(index)) {
        print("정산자가 일치하지 않습니다.");
        return 1;
      }
      if(!ifExistUnChecked(index)) {
        print("아직 처리되지 않은 송금을 확인해주세요.");
        return 2;
      }
      if(isAccountSame(prevAccount, index)) {
        print("정산들의 계좌 정보가 일치하지 않습니다.");
        return 3; // 이후 계좌 정보 합칠건지 말건지 뷰에서 입력 처리
      }
    }

    return 0;
  }

  //앞의 병합 조건들을 모두 만족했다는 전제 하에 해당 메소드 호출하도록
  void mergeSettlements(List<int> indexes, String newName) async {
    if(indexes.length > 10) {
      print("최대 10개까지만 담을 수 있습니다.");
      return;
    }
    Map<String,SettlementPaper> newMergedPapers = <String, SettlementPaper> {};
    //value int값: settlement index 값
    Map<String,List<int>> isCompletedSent = <String, List<int>> {};

    Settlement newMergedSettlement = Settlement();
    newMergedSettlement.settlementName = newName;
    newMergedSettlement.accountInfo = settlementInGroup[indexes[0]].accountInfo;
    newMergedSettlement.masterUserId = settlementInGroup[indexes[0]].masterUserId;
    newMergedSettlement.isMerged = true;

    for(var user in serviceUsers) {
      SettlementPaper newMergedPaper = SettlementPaper();
      newMergedPaper.serviceUserId = user.serviceUserId;
      newMergedPaper.accountInfo = newMergedSettlement.accountInfo;
      newMergedPaper.settlementId = newMergedSettlement.settlementId;
      newMergedPaper.userName = user.name;

      newMergedSettlement.settlementPapers[user.serviceUserId!] = newMergedPaper.settlementPaperId!;
      newMergedPapers[user.serviceUserId!] = newMergedPaper;
      newMergedSettlement.checkSent[user.serviceUserId!] = -1;

      user.settlements.add(newMergedSettlement.settlementId!);
      user.settlementPapers.add(newMergedPaper.settlementPaperId!);
    }

    //병합할 정산들에 대한 병합 과정 진행
    indexes.forEach((index) async {
      newMergedSettlement.receipts.addAll(settlementInGroup[index].receipts);
      
      settlementInGroup[index].receipts.forEach((rcpid) async{
        Receipt rcp = await Receipt().getReceiptByReceiptId(rcpid);
        rcp.settlementId = newMergedSettlement.settlementId;
        FireService().updateDoc("receiptlist", rcpid!, rcp.toJson());
      });

      for(var user in serviceUsers) {
        //해당 정산에 참여하지 않는 유저는 skip
        if(settlementInGroup[index].settlementPapers[user.serviceUserId] == null) {
            continue;
        }
        SettlementPaper paper = await SettlementPaper().getSettlementPaperByPaperId(settlementInGroup[index].settlementPapers[user.serviceUserId]!);
        if(settlementInGroup[index].checkSent[user.serviceUserId!] == 0) {
          newMergedSettlement.checkSent[user.serviceUserId!] = 0;
        }
        else if(settlementInGroup[index].checkSent[user.serviceUserId!] == 3) {
            isCompletedSent[user.serviceUserId!]?.add(index);
            continue;
        }
        SettlementItem title = SettlementItem();
        title.menuName = settlementInGroup[index].settlementName;
        title.receiptItemId = "dummy"; //더미 구분 용도, 메뉴 이름: 정산 이름으로 대체
        newMergedPapers[user.serviceUserId!]?.settlementItems.add(title.settlementItemId!);
        title.createSettlementItem();
        paper.settlementItems.forEach((itemid) {
          newMergedPapers[user.serviceUserId!]!.settlementItems.add(itemid);
        });
        //합쳐진 정산의 개별 정산서의 합계 금액(totalPrice)은 이미 송금 완료된 것을 제외한 것들의 총 합계금액이 됨
        newMergedPapers[user.serviceUserId!]!.totalPrice = newMergedPapers[user.serviceUserId!]!.totalPrice! + paper.totalPrice!;
        user.settlements.remove(settlementInGroup[index].settlementId!);
      }

      newMergedSettlement.totalPrice += settlementInGroup[index].totalPrice;
      FireService().deleteDoc("settlementlist", settlementInGroup[index].settlementId!);
    });

    //모든 정산에 대해 송금 완료가 된 송금자-> checkSent 3(정산 완료)으로 설정, 이미 보낸 정산항목들 처리
    serviceUsers.forEach((user) async {
      if(isCompletedSent[user.serviceUserId!] == null) {
        newMergedSettlement.checkSent[user.serviceUserId!] = 3;
      }
      else {
        SettlementItem completed = SettlementItem();
        completed.menuName = "아래 항목들은 송금을 완료한 정산의 항목들입니다.";
        completed.receiptItemId = "dummy"; //더미 구분 용도
        newMergedPapers[user.serviceUserId!]?.settlementItems.add(completed.settlementItemId!);
        completed.createSettlementItem();

        for (var index in isCompletedSent[user.serviceUserId!]!) {
          SettlementItem title = SettlementItem();
          title.menuName = settlementInGroup[index].settlementName;
          title.receiptItemId = "dummy"; //더미 구분 용도, 메뉴 이름: 정산 이름으로 대체
          newMergedPapers[user.serviceUserId!]?.settlementItems.add(title.settlementItemId!);
          title.createSettlementItem();

          SettlementPaper paper = await SettlementPaper()
              .getSettlementPaperByPaperId(
              settlementInGroup[index].settlementPapers[user.serviceUserId]!);
          paper.settlementItems.forEach((itemid) {
            newMergedPapers[user.serviceUserId!]!.settlementItems.add(itemid);
          });
        }
      }
      newMergedPapers[user.serviceUserId!]!.createSettlementPaper();
      FireService().updateDoc("serviceuserlist", user.serviceUserId!, user.toJson());
    });

    myGroup.settlements.add(newMergedSettlement.settlementId!);
    FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
    newMergedSettlement.time = Timestamp.now();
    newMergedSettlement.createSettlement();
  }




}
