import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_user.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;
final groupCreateProvider = ChangeNotifierProvider<GroupCreateViewModel>(
    (ref) => GroupCreateViewModel());

class GroupCreateViewModel extends ChangeNotifier {
  ServiceUser userData = ServiceUser();
  List<ServiceUser> serviceUsers = [];

  GroupCreateViewModel();

  void settingGroupCreateViewModel(ServiceUser me) async {
    serviceUsers = [me];
    userData = me;
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

    SelectedUsers users =
        await PickerApi.instance.selectFriends(params: params);

    List<ServiceUser> kakaousers = [];
    for (int i = 0; i < users.totalCount; i++) {
      SelectedUser kuser = users.users![i];
      ServiceUser user = ServiceUser();
      user.name = kuser.profileNickname;
      user.kakaoId = kuser.id;
      kakaousers.add(user);
    }

    db.runTransaction((transaction) async {
      await Future.forEach(kakaousers, (user) async {
        user.createUser();
      });
    }).then(
            (value) {
          print("Create Group successfully!");
          notifyListeners();//성공 메시지
        },
        onError: (e) {
          print("Error in creating group $e");//실패 메시지
        }
    );
    serviceUsers.addAll(kakaousers);
    notifyListeners();
  }

  void createGroup(String groupname) async {
    Group group = Group();
    group.groupName = groupname;

    db.runTransaction((transaction) async {
      await Future.forEach(serviceUsers, (user) async {
        final userRef = db.collection("userlist").doc(user.serviceUserId);
        group.serviceUsers.add(user.serviceUserId!);
        if (user.kakaoId == "") {
          // 직접 추가하기로 추가한 그룹원
          user.groups.add(group.groupId!);
          user.createUser(); //DB에 올림
        } else {
          //예몬 친구로 추가한 그룹원
          user.groups.add(group.groupId!);
          transaction.update(userRef, user.toJson());
        }
      });
      group.createGroup();

    }).then(
            (value) {
          print("Create Group successfully!");
          notifyListeners();//성공 메시지
        },
        onError: (e) {
          print("Error in creating group $e");//실패 메시지
        }
    );
  }

  void removeGroupUser(ServiceUser user) {
    serviceUsers.remove(user);
    notifyListeners();
  }

}
