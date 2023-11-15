import 'dart:collection';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupsettlement2/view/complete_settlement_matching.dart';
import 'package:groupsettlement2/class/class_receiptContent.dart';
import 'package:groupsettlement2/view/camera_clova_detect_page.dart';
import 'package:groupsettlement2/view/check_scanned_receipt.dart';
import 'package:groupsettlement2/view/groupMainPage.dart';
import 'package:groupsettlement2/view/group_create_page.dart';
import 'package:groupsettlement2/view/group_select_page.dart';
import 'package:groupsettlement2/view/group_settlement_list_page.dart';
import 'package:groupsettlement2/view/main_page.dart';
import 'package:groupsettlement2/view/mypage.dart';
import 'package:groupsettlement2/view/notification_page.dart';
import 'package:groupsettlement2/view/settlementDetailPage.dart';
import 'package:groupsettlement2/view/create_new_settlement.dart';
import 'package:groupsettlement2/view/edit_receipt.dart';
import 'package:groupsettlement2/view/groupMainPage.dart';
import 'package:groupsettlement2/view/settlementDetailPage.dart';
import 'package:groupsettlement2/view/settlementGroupSelectionPage.dart';
import 'package:groupsettlement2/class/class_settlement.dart';
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
        return const mainPage();
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
            path: 'KakaoLoginPage',
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
              List<String> ids = state.extra as List<String>;
              return groupMainPage(ids: ids);
            }),
        GoRoute(
            path: 'SettlementDetailPage/:settlementId/:groupname/:userId',
            builder: (context, state) {
              return SettlementDetailPage(
                settlementId: state.pathParameters["settlementId"]!,
                groupname: state.pathParameters["groupname"]!,
                userId: state.pathParameters["userId"]!,
              );
            }),
        GoRoute(
            path: 'CreateNewSettlementPage/:groupId/:masterId/:accountInfo',
            builder: (context, state) {
              return CreateNewSettlement(
                groupId: state.pathParameters["groupId"]!,
                masterId: state.pathParameters["masterId"]!,
                accountInfo: state.pathParameters["accountInfo"]!,
              );
            },
            routes: [
              GoRoute(
                path: 'EditReceiptPage/:modifyFlag',
                builder: (context, state) {
                  ReceiptContent content = state.extra as ReceiptContent;
                  return EditReceiptPage(
                    receiptContent: content,
                    modifyFlag: state.pathParameters["modifyFlag"]!,
                  );
                },
              ),
              // GoRoute(
              //   path: 'cameraDetectPage',
              //   builder: (context, state) => cameraDetectPage(camera: state.qu),
              // ),
            ]),
        GoRoute(
          path: "SettlementPage/:settlementId",
          builder: (context, state) {
            return SettlementPage(
              settlementId: state.pathParameters["settlementId"]!,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'CompleteSettlementMatching',
              builder: (context, state) {
                return const CompleteSettlementMatching();
              },
            ),
          ],
        ),
        GoRoute(
            path: 'SettlementFinalCheckPage',
            builder: (context, state) {
              return const SettlementFinalCheckPage();
            }),
        GoRoute(
            path: 'SettlementGroupSelectionPage',
            builder: (context, state) {
              String userId = state.extra as String;
              return settlementGroupSelectionPage(userId: userId);
            }),
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
          path: "GroupSelectPage/:userId",
          builder: (context, state) {
            return groupSelectPage(userId: state.pathParameters["userId"]!);
          },
        ),
        GoRoute(
          path: "GroupSettlementListPage",
          builder: (context, state) {
            return const groupSettlementListPage();
          },
        ),
        GoRoute(
          path: "cameraDetectPage",
          builder: (context, state) {
            CameraDescription camera = state.extra as CameraDescription;
            return cameraDetectPage(extra: camera);
          },
        ),
        GoRoute(
          path: "scanedRecieptPage",
          builder: (context, state) {
            ReceiptContent content = state.extra as ReceiptContent;
            return CheckScannedReceiptPge(
              receiptContent: content,
            );
          },
        ),
        GoRoute(
          path: "mp",
          builder: (context, state) {
            return mainPage();
          },
        ),
        GoRoute(
          path: "kakaoPage",
          builder: (context, state) {
            return kakaoLoginPage();
          },
        )
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
    user.tokenTimestamp = Timestamp.now();
    FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
  }

  void _checkToken(String userid) async {
    ServiceUser user = await ServiceUser().getUserByUserId(userid);
    var nowtime = DateTime.now().millisecondsSinceEpoch;
    //DateTime prevtime = DateTime.parse(user.tokenTimestamp!.toDate().toString());
    if (user.fcmToken == "") {
      _getMyDeviceToken(user);
    } else if( (nowtime - DateTime.parse(user.tokenTimestamp!.toDate().toString()).millisecondsSinceEpoch) / (1000 * 60 * 60 * 24)  >= 28 ) {
      _getMyDeviceToken(user);
    }
  }

  @override
  void initState() {
    super.initState();
    //_getMyDeviceToken(me);
    _checkToken("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb");
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
