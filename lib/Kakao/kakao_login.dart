import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'social_login.dart';


class kakaoLogin implements socialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled(); //카카오톡 설치 확인
      if (isInstalled) { //설치되어 있다면
        try { //카카오톡 로그인 시도
          await UserApi.instance.loginWithKakaoTalk(); //카카오톡 로그인
          return true; //성공하면 true
        }
        catch (error) { //error 발견하면
          return false; //return false
        }
      }
      else { //카카오톡 설치되어 있지 않다면
        try { //카카오톡 계정으로 로그인 시도
          await UserApi.instance.loginWithKakaoAccount(); //카카오톡 계정 로그인
          return true; //성공하면 true
        }
        catch (error) { //error 발견하면
          return false; //return false
        }
      }
    }
    catch (error) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    }
    catch (error) {
      return false;
    }
  }

}