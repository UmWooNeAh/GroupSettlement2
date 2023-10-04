import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

class GroupViewModel extends ChangeNotifier {

  Group myGroup = Group();
  List<ServiceUser> serviceUsers = <ServiceUser> [];
  List<Settlement> settlementInGroup = <Settlement> [];
  List<Settlement> mergedSettlementInGroup = <Settlement> [];

  GroupViewModel(String groupId) {
    _settingGroupViewModel(groupId);
  }

  void _settingGroupViewModel(String groupId) async {
    myGroup = await Group().getGroupByGroupId(groupId);

    myGroup.serviceUsers.forEach((userid) async {
      serviceUsers.add(await ServiceUser().getUserByUserId(userid));
      notifyListeners();
    });

    myGroup.settlements.forEach((stmid) async {
      Settlement stm = await Settlement().getSettlementBySettlementId(stmid);

      if(!stm.mergedSettlement.isEmpty) {
        mergedSettlementInGroup.add(stm);
        //log("합쳐진 정산: ${stm.settlementName}");
      }
      else {
        settlementInGroup.add(stm);
        //log("그냥 정산: ${stm.settlementName}");
      }
      notifyListeners();
    });

  }

  void updateSettlement(String settlementId) async {
    Settlement data = await Settlement().getSettlementBySettlementId(settlementId);
    settlementInGroup.add(data);
    notifyListeners();
  }

  void addByDirect(ServiceUser user) {
    serviceUsers.add(user);
    user.createUser();
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

  void updateGroupName(String GroupId, String name){
    myGroup.groupName = name;
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

  void createGroup(String groupname) async {
    myGroup.groupName = groupname;
    for(var user in serviceUsers) {
          myGroup.serviceUsers.add(user.serviceUserId!);
    }
    myGroup.createGroup();
    notifyListeners();
  }

  void mergeSettlement(Settlement stm1, Settlement stm2, String newName) async {

    if(stm1.mergedSettlement.length > 0) { //합쳐진 정산 + 하나의 정산
        stm1.mergedSettlement.add(stm2.settlementId!);
        stm2.isMerged = true;
        FireService().updateDoc("settlementlist", stm1.settlementId!, stm1.toJson());
    }
    else  { //하나의 정산 + 하나의 정산
      Settlement newMergedStm = Settlement();
      newMergedStm.settlementName = newName;
      newMergedStm.mergedSettlement.addAll([stm1.settlementId!, stm2.settlementId!]);
      stm1.isMerged = true; stm2.isMerged = true;
      newMergedStm.createSettlement();
      FireService().updateDoc("settlementlist", stm1.settlementId!, stm1.toJson());
      FireService().updateDoc("settlementlist", stm2.settlementId!, stm2.toJson());
      myGroup.settlements.add(newMergedStm.settlementId!);
      mergedSettlementInGroup.add(newMergedStm);
    }
    notifyListeners();
  }

  void disassembleMergedSettlement(Settlement mergedSettlement) async {

    mergedSettlement.mergedSettlement.forEach((stmid) async {
      Settlement stm = await Settlement().getSettlementBySettlementId(stmid);
      stm.isMerged = false;
      FireService().updateDoc("settlementlist", stm.settlementId!, stm.toJson());
    });

    FireService().deleteDoc("settlementlist", mergedSettlement.settlementId!);
    myGroup.settlements.remove(mergedSettlement.settlementId);
    mergedSettlementInGroup.remove(mergedSettlement);
    notifyListeners();
  }

  void pilferFromMergedSettlement(Settlement mergedSettlement, String stmid) async {
    Settlement stm = await Settlement().getSettlementBySettlementId(stmid);
    stm.isMerged = false;
    FireService().updateDoc("settlementlist", stm.settlementId!, stm.toJson());

    mergedSettlement.mergedSettlement.remove(stmid);
    FireService().updateDoc("settlementlist", mergedSettlement.settlementId!, mergedSettlement.toJson());
    notifyListeners();
  }
  
}
