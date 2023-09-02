import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'kakao_login_page.dart';

class kakaoFriends{

  var params = PickerFriendRequestParams(
    title:'친구 피커',
    enableSearch: true,
    showMyProfile: true,
    showFavorite: true,
    showPickedFriend: true,
    maxPickableCount: null,
    minPickableCount: 1,
    enableBackButton: true,
  );

  // Future<SelectedUsers> picker() async{
  //   try{
  //     SelectedUsers users = await PickerApi.instance.selectFriends(params:params,context:);
  //     print('선택 성공');
  //     return users;
  //   }catch(e){
  //     print('선택 실패 : $e');
  //     return SelectedUsers(totalCount: 0);
  //   }
  // }

}