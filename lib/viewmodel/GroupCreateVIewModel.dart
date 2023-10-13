import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';


final groupProvider = ChangeNotifierProvider<GroupCreateViewModel>(
        (ref) => GroupCreateViewModel("8dcca5ca-107c-4a12-9d12-f746e2e513b7"));

class GroupCreateViewModel extends ChangeNotifier {

  ServiceUser userData = ServiceUser();
  Group group = Group();
  List<String> serviceUsers = [];
  List<ServiceUser> directedUsers = []; //DB 등록용 직접 추가 유저들

  GroupCreateViewModel(String userId) {
    _settingGroupViewModel(userId);
  }

  void _settingGroupViewModel(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
  }

  void addByDirect(String userName) {
    ServiceUser user = ServiceUser();
    user.name = userName;
    serviceUsers.add(user.serviceUserId!);
    directedUsers.add(user);
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
      serviceUsers.add(user.serviceUserId!);
    }
    notifyListeners();
  }

  void createGroup(String groupname) async {
    group.groupName = groupname;
    for(var user in serviceUsers) {
      group.serviceUsers.add(user);
    }
    for(var directeduser in directedUsers) {
      directeduser.createUser();
    }
    group.createGroup();
    notifyListeners();
  }

}