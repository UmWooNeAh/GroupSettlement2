import 'package:flutter/material.dart';
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
                  children : [
                  Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? '',
                  width: 80.0, height: 80.0),
                  SizedBox(width: 30.0),
                  Text(viewModel.user?.kakaoAccount?.profile?.nickname ?? '', style: TextStyle(fontSize: 25.0),)
                ]
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      "로그인",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                              ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kPrimary,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0))
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await viewModel.logout();
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      "로그아웃",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0))
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try{
                      await UserApi.instance.loginWithNewScopes(["friends","talk_message"]);
                    }catch(error){
                      print('실패');
                    }

                    try {
                      final FeedTemplate defaultFeed = FeedTemplate(
                        content: Content(
                          title: '류지원님이 정산 요청을 보냈어요.\n내역을 확인한 후 송금해주세요',
                          description: '국민 000-00000000-00',
                          imageUrl: Uri.parse(
                              'https://www.press9.kr/news/photo/201910/30004_craw1.jpg'),
                          link: Link(
                              webUrl: Uri.parse('https://fir-df691.web.app/#/'),
                              mobileWebUrl: Uri.parse('https://fir-df691.web.app/#/')),
                        ),
                        itemContent: ItemContent(
                          profileText: '그룹 정산(혹은 그룹 이름)',
                          profileImageUrl: Uri.parse(
                                'https://engineering.linecorp.com/wp-content/uploads/2019/08/flutter1.png'),
                          titleImageUrl: Uri.parse(
                                'https://engineering.linecorp.com/wp-content/uploads/2019/08/flutter1.png'),
                          titleImageText: '경대루 (정산 이름)',
                          titleImageCategory: '경대루, 카페유즈',
                          items: [
                            ItemInfo(item: '류지원', itemOp: '15000원'),
                            ItemInfo(item: '신성민', itemOp: '21000원'),
                            ItemInfo(item: '박건우', itemOp: '13000원'),
                            ItemInfo(item: '조우석', itemOp: '10500원')
                          ],
                          sum: 'total',
                          sumOp: '59500원',
                        ),
                        buttons: [
                          Button(
                            title: '정산서 보기',
                            link: Link(
                              webUrl: Uri.parse('https://fir-df691.web.app/#/'),
                              mobileWebUrl: Uri.parse('https://fir-df691.web.app/#/'),
                            ),
                          ),
                          Button(
                            title: '앱으로보기',
                            link: Link(
                              androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                              iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                            ),
                          ),
                        ],
                      );
                      try {
                        Uri shareUrl = await WebSharerClient.instance
                            .makeDefaultUrl(template: defaultFeed);
                        await launchBrowserTab(shareUrl, popupOpen: true);
                      } catch (error) {
                        print('카카오톡 공유 실패 $error');
                      }
                    }catch(e){
                      print('---------------------- $e -----------------');
                    }
                    print('친구 선택 성공');
                    setState(() {
                    });
                  },
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
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0))
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var params = PickerFriendRequestParams(
                      title: '멀티 친구 피커',
                      enableSearch: true,
                      showMyProfile: true,
                      showFavorite: true,
                      showPickedFriend: null,
                      maxPickableCount: null,
                      minPickableCount: null,
                      enableBackButton: true,
                    );

// 피커 호출
                    try {
                      SelectedUsers users = await PickerApi.instance.selectFriends(params: params, context: context);
                      print('친구 선택 성공: ${users.users!.length}');
                    } catch(e) {
                      print('친구 선택 실패: $e');
                    }
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      "피커로 선택하기",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0))
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }
}
