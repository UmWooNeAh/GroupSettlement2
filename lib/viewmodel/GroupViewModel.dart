import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
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

  
}
