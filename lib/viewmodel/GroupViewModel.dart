import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

class GroupViewModel {

  Group myGroup;
  List<Settlement> settlementGroup;
  List<ServiceUser> users;

  GroupViewModel({
    required this.myGroup,
    required this.settlementGroup,
    required this.users
  });

  updateSettlement(String settlementId) async {
    Settlement data = await Settlement().getSettlementBySettlementId(settlementId);
    settlementGroup.add(data);
  }

  createGroup(Group myGroup, List<ServiceUser> users) {
    this.myGroup = myGroup;
    this.users = users;
    settlementGroup = [];
  }

  addByKakaoFriends() async {
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

      ServiceUser user = ServiceUser(serviceUserId: "null", name: kuser.profileNickname, kakaoId: kuser.id);
      user.createUser();

      this.users.add(user);
    }
  }

  addByDirect(String userId, String Name, String kId){
    ServiceUser user = ServiceUser(serviceUserId: userId, name: Name, kakaoId: kId);
    user.createUser();

    this.users.add(user);
  }

  deleteUser(String userId){
    this.users.removeWhere((user) => user.serviceUserId == userId);
  }

  updateGroupName(String GroupId, String name){
    myGroup.groupName = name;
    FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());
    //myGroup.UpdateGroup();
    // Group group = await Group().getGroupByGroupId(GroupId);
    // group.GroupName = name;
    // group.updateGroup();
  }

  updateUserName(String userId, String newName) async{
    ServiceUser user = await ServiceUser().getUserByUserId(userId);
    if(user.kakaoId == null) {
      user.name = newName;
      FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
      //user.UpdateUser();
    }
    else {
      print("카카오톡으로 추가한 유저의 이름은 변경할 수 없습니다.");
    }
  }
}
