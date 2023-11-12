import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

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
    notifyListeners();
  }

  // void mergeSettlementV1(Settlement stm1, Settlement stm2, String newName) async {
  //   //하나의 정산 + 하나의 정산
  //   MergedSettlement newMergedStm = MergedSettlement();
  //   newMergedStm.groupId = myGroup.groupId;
  //   newMergedStm.settlementName = newName;
  //   newMergedStm.mergedSettlements.addAll([stm1.settlementId!, stm2.settlementId!]);
  //   newMergedStm.totalPrice = stm1.totalPrice + stm2.totalPrice;
  //   newMergedStm.time = Timestamp.now();
  //   newMergedStm.createSettlement();

  //   stm1.isMerged = true; stm2.isMerged = true;
  //   FireService().updateDoc("settlementlist", stm1.settlementId!, stm1.toJson());
  //   FireService().updateDoc("settlementlist", stm2.settlementId!, stm2.toJson());
  //   myGroup.mergedSettlements.add(newMergedStm.settlementId!);
  //   FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
  //   mergedSettlementInGroup.add(newMergedStm);
  //   notifyListeners();

  // }

  /*void makeOneMergedSettlement(MergedSettlement newMergedStm) async {
      //하나의 정산 + 하나의 정산
      MergedSettlement newMergedStm = MergedSettlement();
      if(stm1.masterUserId != stm2.masterUserId) {
        newMergedStm.masterUserIds.addAll(
            [stm1.masterUserId!, stm2.masterUserId!]);
      } else {
        newMergedStm.masterUserIds.add(stm1.masterUserId!);
      }

      newMergedStm.receipts.addAll(stm1.receipts); newMergedStm.receipts.addAll(stm2.receipts);
      stm1.settlementPapers.forEach((key, value) {
        newMergedStm.settlementPapers[key]?.add(value);
      });
      stm2.settlementPapers.forEach((key, value) {
        newMergedStm.settlementPapers[key]?.add(value);
      });
      stm1.checkSent.forEach((key, value) {
        newMergedStm.checkSent[key] = value;
      });
      stm2.checkSent.forEach((key, value) {
        if(newMergedStm.checkSent[key] == 3 && value == 3) {
          newMergedStm.checkSent[key] = 3;
        }
        else {
          newMergedStm.checkSent[key] = 0;
        }
      });
      newMergedStm.accountInfos[stm1.settlementId!] = stm1.accountInfo!;
      newMergedStm.accountInfos[stm2.settlementId!] = stm2.accountInfo!;
  }*/

  // void mergeSettlementV2(MergedSettlement mergedStm, Settlement stm) {
  //   // 기존 합쳐진 정산 + 새로운 정산
  //   mergedStm.mergedSettlements.add(stm.settlementId!);
  //   mergedStm.totalPrice += stm.totalPrice;
  //   mergedStm.time = Timestamp.now();
  //   FireService().updateDoc("mergedsettlementlist", mergedStm.settlementId!, mergedStm.toJson());
  //   stm.isMerged = true;
  //   FireService().updateDoc("settlementlist", stm.settlementId!, stm.toJson());
  //   notifyListeners();
  // }
}
