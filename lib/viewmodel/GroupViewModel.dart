import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../class_group.dart';
import '../class_settlement.dart';
import '../class_settlementpaper.dart';
import '../class_user.dart';

class GroupViewModel {

  Group myGroup;
  List<Settlement> settlementGroup;
  List<User> users;

  GroupViewModel({
    required this.myGroup,
    required this.settlementGroup,
    required this.users
  });

  updateSettlement(String settlementId) async{
    Settlement data = await Settlement().getSettlementBySettlementId(settlementId);
    settlementGroup.add(data);
  }

  createGroup(Group myGroup,List<User> users){
    this.myGroup = myGroup;
    this.users = users;
    settlementGroup = [];
  }

  addByKakaoFriends() async{
    var params = PickerFriendRequestParams(
      title: 'Multi Picker',
      enableSearch: true,
      showMyProfile: false,
      showFavorite: true,
      showPickedFriend: true,
      maxPickableCount: null,
      minPickableCount: null,
      enableBackButton: true;
    );
    
    SelectedUsers users = await PickerApi.instance.selectFriends(
          params: params);

    for(int i=0;i<users.totalCount;i++){
      SelectedUser kuser = users.users![i];
      User user = User().createUser("null",kuser.profileNickname,kuser.id);
      this.users.add(user);
    }
  }

  addByDirect(String userId,String Name,String kId){
    User user = User().createUser(userId,Name,kId);
    this.users.add(user);
  }

  deleteUser(String userId){
    this.users.removeWhere((user) => user.UserId == userId);
  }

  updateGroupName(String GroupId,String name){
    myGroup.GroupName = name;
    myGroup.updateGroup();

    // Group group = await Group().getGroupByGroupId(GroupId);
    // group.GroupName = name;
    // group.updateGroup();
  }

  updateUserName(String userId,String newName) async{
    User user = await User().getUserByUserId(userId);
    if(user.KakaoId == null){
      user.Name = newName;
      user.UpdateUser();
    }else{
      print("You cannot modify user added by Kakao");
    }
  }
}
