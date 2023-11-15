import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../class/class_receipt.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';
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
        '\n닉네임: ${user?.kakaoAccount?.profile?.nickname}'
        '\n아이디: ${user?.kakaoAccount?.legalName}'
    );
  }
  Future logout() async {
    await _socialLogin.logout(); //로그아웃 실행
    isLogined = false; //로그인되어 있는지를 저장하는 변수 false값 저장
    user = null; //user 객체 null
  }

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

  FeedTemplate makeFeed(ServiceUser user,Settlement settlement, Receipt receipt){
    return FeedTemplate(
      content: Content(
        title: '${user.name}님이 정산 요청을 보냈어요.\n내역을 확인한 후 송금해주세요',
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
        titleImageCategory: receipt.storeName,
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
  }
  FeedTemplate makedebugFeed() {
    return FeedTemplate(
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
        titleImageCategory: '경대루, 카페 유즈',
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
  }
}