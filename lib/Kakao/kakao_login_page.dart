import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'kakao_login.dart';
import 'login_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

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
        title: Text("카카오톡 로그인"),
      ),
      body: Center(
        child: StreamBuilder<fbAuth.User?>(
            stream: fbAuth.FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return IconButton(
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
                  },
                  icon: Image.asset('images/kakao_login_medium_wide.png'),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                      viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                          ''),
                  Text(
                    '${viewModel.isLogined}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  IconButton(
                    onPressed: () async {
                      await viewModel.logout();
                      setState(() {});
                    },
                    icon: Image.asset('images/kakao_logout_medium_wide.png'),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
