import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';


final groupProvider = ChangeNotifierProvider<GroupCreateViewModel>(
        (ref) => GroupCreateViewModel("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb"));

class GroupCreateViewModel extends ChangeNotifier {

  ServiceUser userData = ServiceUser();
  Group group = Group();
  List<ServiceUser> serviceUsers = [];

  GroupCreateViewModel(String userId) {
    serviceUsers = [];
    settingGroupViewModel(userId);
  }

  void settingGroupViewModel(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
    serviceUsers.add(userData);
    notifyListeners();
  }

  void addByDirect(String userName) {
    ServiceUser user = ServiceUser();
    user.name = userName;
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

  void createGroup(String groupname) async {
    group.groupName = groupname;

    for(var user in serviceUsers) {
      group.serviceUsers.add(user.serviceUserId!);
      if(user.kakaoId == null) { // 직접 추가하기로 추가한 그룹원
        user.createUser(); //DB에 올림
      }
      else { //예몬 친구로 추가한 그룹원
        user.groups.add(group.groupId!);
        FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
      }
    }
    group.createGroup();
    notifyListeners();
  }

}