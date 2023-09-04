import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';



class MainViewModel {
  final socialLogin _socialLogin;
  bool isLogined = false; //처음에 로그인 안 되어 있음
  User? user; //카카오톡에서 사용자 정보를 저장하는 객체 User를 nullable 변수로 선언
  SelectedUsers? users;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login(); //로그인되어 있는지 확인
    user = await UserApi.instance.me(); //사용자 정보 받아오기
    print('사용자 정보 요청 성공'
        '\n회원번호: ${user?.id}'
        '\n닉네임: ${user?.kakaoAccount?.profile?.nickname}');
  }
  Future logout() async {
    await _socialLogin.logout(); //로그아웃 실행
    isLogined = false; //로그인되어 있는지를 저장하는 변수 false값 저장
    user = null; //user 객체 null
  }



}