import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'kakao_login.dart';
import 'login_viewmodel.dart';

class kakaoLoginPage extends StatefulWidget {
  const kakaoLoginPage({Key? key}) : super(key: key);

  @override
  State<kakaoLoginPage> createState() => _kakaoLoginPageState();
}

class _kakaoLoginPageState extends State<kakaoLoginPage> {
  final viewModel = MainViewModel(kakaoLogin());
  get borderRadius => null;
  get kPrimary => null;

  @override
  void initState(){
    if(viewModel.isLogined) {
      print("already logged in");
      context.go("/MainPage");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : viewModel.isLogined ? [
                  Image.network(viewModel.user!.kakaoAccount!.profile!.profileImageUrl!,
                  width: 80.0, height: 80.0),
                  SizedBox(width: 30.0),
                  Text(viewModel.user?.kakaoAccount?.profile?.nickname ?? '', style: TextStyle(fontSize: 25.0),)
                ] : [Text("로그인 화면입니다.")]
              ),
              Expanded(
                child:Center(child:null),
              ),
              Row(
                children:[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await UserApi.instance.loginWithNewScopes(["friends","talk_message"]);

                        try {
                          Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: viewModel.makedebugFeed());
                          await launchBrowserTab(shareUrl, popupOpen: true);
                        } catch (error) {
                            print('카카오톡 공유 실패 $error');
                        }
                        print('친구 선택 성공');
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kPrimary,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.0))
                      ),
                      child: Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          "정산서 전송",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 16.0,
                  //       right: 16.0),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       // 친구 목록 및 메시지 권한 받기
                  //       await UserApi.instance.loginWithNewScopes(["friends","talk_message"]);
                  //       List<String> ids = [];
                  //       // 피커 호출
                  //       try {
                  //         SelectedUsers users = await PickerApi.instance.selectFriends(params: viewModel.params, context: context);
                  //         print('친구 선택 성공: ${users.users!.length}');
                  //         users.users!.forEach((user){
                  //           ids.add(user.uuid);
                  //         });
                  //       } catch(e) {
                  //         print('친구 선택 실패: $e');
                  //       }
                  //
                  //       try{
                  //         MessageSendResult result = await TalkApi.instance.sendDefaultMessage(
                  //             receiverUuids: ids, template: viewModel.makedebugFeed());
                  //         print('메시지 전송 성공 ${result.successfulReceiverUuids}');
                  //       }catch(e){
                  //         print('메시지 전송 오류: $e');
                  //       }
                  //       setState(() {
                  //       });
                  //
                  //     },
                  //     child: Container(
                  //       height: 45.0,
                  //       alignment: Alignment.center,
                  //       child: Text(
                  //         "피커로 선택하기",
                  //         style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  //             fontSize: 18.0,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold
                  //         ),
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //         primary: kPrimary,
                  //         elevation: 5.0,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(45.0))
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 25,
                      bottom: 25),
                  child:IconButton(
                      padding: EdgeInsets.zero,
                      icon: viewModel.isLogined ? Image.asset('images/kakao_logout_medium_wide.png') : Icon(Icons.login)/*Image.asset('images/kakao_login_medium_wide.png')*/,

                      onPressed:()async{
                        if(viewModel.isLogined) {
                          //await viewModel.logout();
                          context.go("/MainPage");
                        }else{
                          await viewModel.login();
                          context.go("/MainPage");
                        }
                        setState(() {});
                      }
                  )

              ),
            ],
          )
        )
      )
    );
  }
}
