import 'dart:collection';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupsettlement2/view/camera_clova_detect_page.dart';
import 'package:groupsettlement2/view/groupMainPage.dart';
import 'package:groupsettlement2/view/group_create_page.dart';
import 'package:groupsettlement2/view/group_select_page.dart';
import 'package:groupsettlement2/view/group_settlement_list_page.dart';
import 'package:groupsettlement2/view/mypage.dart';
import 'package:groupsettlement2/view/notification_page.dart';
import 'package:groupsettlement2/view/settlementDetailPage.dart';
import 'package:groupsettlement2/view/create_new_settlement.dart';
import 'package:groupsettlement2/view/edit_receipt.dart';
import 'package:groupsettlement2/view/groupMainPage.dart';
import 'package:groupsettlement2/view/settlementDetailPage.dart';
import 'package:groupsettlement2/view/settlementGroupSelectionPage.dart';
import 'package:groupsettlement2/class/class_settlement.dart';
import 'package:groupsettlement2/view/settlement_detail_page_sender.dart';
import 'package:groupsettlement2/view/settlement_final_check.dart';
import 'package:groupsettlement2/view/total_settlement_details_management.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/view/MainPage.dart';
import 'package:groupsettlement2/view/gun_page.dart';
import 'package:groupsettlement2/view/ryu_page.dart';
import 'package:groupsettlement2/view/settlement_page.dart';
import 'package:groupsettlement2/view/sin_page.dart';
import 'package:groupsettlement2/view/viewmodelTest_page.dart';
import 'package:groupsettlement2/view/viewmodelTest_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'clova/clova.dart';
import 'clova/clovaPage.dart';
import 'design_element.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'Kakao/kakao_login_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}


void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'hight_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}

final firstProvider = Provider((_) => 'Hello World');
final GoRouter _router = GoRouter(
  initialLocation: "/SplashView",
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MainPage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'SplashView',
            builder: (context, state) {
              return const SplashView();
            }),
        GoRoute(
            path: 'RyuPage',
            builder: (context, state) {
              return const RyuPage();
            }),
        GoRoute(
            path: 'SinPage',
            builder: (context, state) {
              return const SinPage();
            }),
        GoRoute(
            path: 'VMTestPage',
            builder: (context, state) {
              return const VMTestPage();
            }),
        GoRoute(
            path: 'GunPage',
            builder: (context, state) {
              return const GunPage();
            }),
        GoRoute(
            path: 'kakaoLoginPage',
            builder: (context, state) {
              return const kakaoLoginPage();
            }),
        GoRoute(
            path: 'clovaPage',
            builder: (context, state) {
              return const clovaPage();
            }),
        GoRoute(
            path: 'groupMainPage',
            builder: (context, state) {
              return const groupMainPage();
            }),
        GoRoute(
            path: 'settlementDetailPage',
            builder: (context, state) {
              return const SettlementDetailPageSettlementer();
            }),
        GoRoute(
            path: 'CreateNewSettlementPage',
            builder: (context, state) {
              return const CreateNewSettlement();
            },
            routes: [
              GoRoute(
                path: 'EditReceiptPage',
                builder: (context, state) {
                  return const EditReceiptPage();
                },
              ),
              // GoRoute(
              //   path: 'cameraDetectPage',
              //   builder: (context, state) => cameraDetectPage(camera: state.qu),
              // ),
            ]),
        GoRoute(
          path: "SettlementPage",
          builder: (context, state) {
            return const SettlementPage();
          },
          routes: <RouteBase>[
            GoRoute(
                path: 'SettlementFinalCheckPage',
                builder: (context, state) {
                  return const SettlementFinalCheckPage();
                }),
          ],
        ),
        GoRoute(
            path: 'settlementGroupSelectionPage',
            builder: (context, state) {
              return const settlementGroupSelectionPage();
            }),
        GoRoute(
          path: "SettlementDetailPageSender",
          builder: (context, state) {
            return const SettlementDetailPageSender();
          },
        ),
        GoRoute(
          path: "MyPage",
          builder: (context, state) {
            return const myPage();
          },
        ),
        GoRoute(
          path: "NotificationPage",
          builder: (context, state) {
            return const notificationPage();
          },
        ),
        GoRoute(
          path: "GroupCreatePage",
          builder: (context, state) {
            return const groupCreatePage();
          },
        ),
        GoRoute(
          path: "GroupSelectPage",
          builder: (context, state) {
            return const groupSelectPage();
          },
        ),
        GoRoute(
          path: "GroupSettlementListPage",
          builder: (context, state) {
            return const groupSettlementListPage();
          },
        ),
        GoRoute(
          path: "GroupSettlementListPage",
          builder: (context, state) {
            return const groupSettlementListPage();
          },
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp() 호출 전 Flutter SDK 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotification();
  // KakaoSdk 초기화
  // final nativeKey = await File("./Kakao/kakaoKey.txt").readAsString();
  // final jsKey = await File("./Kakao/kakaoJsKey.txt").readAsString();
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
      nativeAppKey: '00b83bf69fba554145c773d6737772fc',
      javaScriptAppKey: 'aa3a51d84f03c87a103a1a127dfcd8f9');
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  var messageString = "";
  ServiceUser me = ServiceUser();

  void _getMyDeviceToken(ServiceUser user) async {
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
    user.fcmToken = token;
    user.tokenTimestamp = DateTime.now().millisecondsSinceEpoch;
  }

  void _checkToken(String userid) async {
    ServiceUser user = await ServiceUser().getUserByUserId(userid);
    int nowtime = DateTime.now().millisecondsSinceEpoch;
    if (user.fcmToken == null ||
        (nowtime - user.tokenTimestamp!) / (1000 * 60 * 60 * 24 * 30) >= 28) {
      _getMyDeviceToken(user);
      FireService().updateDoc("userlist", userid, user.toJson());
    }
  }

  @override
  void initState() {
    super.initState();
    _getMyDeviceToken(me);
    // _checkToken(me.serviceUserId!);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'hight_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );
        messageString = message.notification!.body!;
        print("Foreground 메시지 수신: $messageString");
      }
    });

    Timer(
      const Duration(seconds: 2),
      () {
        context.go("/");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Container(
            color: Colors.white,
          ),
        ),
        Center(
          child: Container(
              height: 100, width: 100, color: Colors.deepPurpleAccent),
        ),
        Positioned(
          bottom: size.height * 0.6,
          child: Transform.rotate(
            angle: pi * 3 / 4,
            child: Container(
              height: size.width * 1.7,
              width: size.width,
              color: color1,
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.6,
          child: Transform.rotate(
            angle: pi * 3 / 4,
            child: Container(
              height: size.width * 1.7,
              width: size.width,
              color: color2,
            ),
          ),
        ),
      ],
    );
  }
}
