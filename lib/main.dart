import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupsettlement2/class/class_receiptContent.dart';
import 'package:groupsettlement2/view/group_create_page.dart';
import 'package:groupsettlement2/view/group_main_page.dart';
import 'package:groupsettlement2/view/group_select_page.dart';
import 'package:groupsettlement2/view/group_settlement_list_page.dart';
import 'package:groupsettlement2/view/main_page.dart';
import 'package:groupsettlement2/view/mypage_page.dart';
import 'package:groupsettlement2/view/notification_page.dart';
import 'package:groupsettlement2/view/receipt_add_page.dart';
import 'package:groupsettlement2/view/receipt_box_page.dart';
import 'package:groupsettlement2/view/receipt_check_scanned_page.dart';
import 'package:groupsettlement2/view/receipt_edit_page.dart';
import 'package:groupsettlement2/view/settlement_create_page.dart';
import 'package:groupsettlement2/view/settlement_final_check.dart';
import 'package:groupsettlement2/view/settlement_group_select_page.dart';
import 'package:groupsettlement2/view/settlement_information_page.dart';
import 'package:groupsettlement2/view/settlement_matching_complete_page.dart';
import 'package:groupsettlement2/view/settlement_matching_page.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/view/viewmodelTest_page.dart';
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

Future<void> initializeNotification() async {

  const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    'high_importance_channel', // 임의의 id
    'High Importance Notifications', // 설정에 보일 채널명
    importance: Importance.max,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ),
    onDidReceiveNotificationResponse: onSelectNotification,
    onDidReceiveBackgroundNotificationResponse: onSelectNotification,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true
  );

}

void onSelectNotification(NotificationResponse details) async { // 여기서 핸들링!
    if(details.payload != null) {
      Map<String, dynamic> data = jsonDecode(details.payload ?? "");
      _router.push(data["route"]);
    }
}

void showFlutterNotificaiton(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      payload: jsonEncode(message.data),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hight_importance_channel',
          'high_importance_notification',
        ),
      ),
    );
    var messageString = message.notification!.body!;
    print("Foreground 메시지 수신: $messageString");
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeNotification();
}

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
            path: "GroupSelect",
            builder: (context, state) {
              ServiceUser me = state.extra as ServiceUser;
              return GroupSelectPage(me: me);
            },
            routes: [
              GoRoute(
                  path: 'GroupMain',
                  builder: (context, state) {
                    List<dynamic> info = state.extra as List<dynamic>;
                    return GroupMainPage(info: info);
                  },
                  routes: [
                    GoRoute(
                      path: "GroupSettlementList",
                      builder: (context, state) {
                        return const GroupSettlementListPage();
                      },
                    )
                  ]),
            ]),
        GoRoute(
            path: "GroupCreate",
            builder: (context, state) {
              ServiceUser me = state.extra as ServiceUser;
              return GroupCreatePage(me: me);
            }),
        GoRoute(
            path: 'SettlementGroupSelect',
            builder: (context, state) {
              ServiceUser me = state.extra as ServiceUser;
              return SettlementGroupSelectPage(me: me);
            }),
        GoRoute(
            path: 'SettlementInformation',
            builder: (context, state) {
              List<dynamic> info = state.extra as List<dynamic>;
              return SettlementInformationPage(info: info);
            }),
        GoRoute(
            path: 'SettlementCreate',
            builder: (context, state) {
              List<dynamic> info = state.extra as List<dynamic>;
              return SettlementCreatePage(info: info);
            }),
        GoRoute(
            path: 'ReceiptAdd',
            builder: (context, state) {
              Object camera = state.extra as Object;
              return ReceiptAddPage(camera: camera);
            }),
        GoRoute(
            path: 'ReceiptBox',
            builder: (context, state) {
              return const ReceiptBoxPage();
            }),
        // GoRoute(
        //     path: 'VMTestPage',
        //     builder: (context, state) {
        //       return const VMTestPage();
        //     }),
        // GoRoute(
        //     path: 'KakaoLoginPage',
        //     builder: (context, state) {
        //       return const kakaoLoginPage();
        //     }),
        // GoRoute(
        //     path: 'clovaPage',
        //     builder: (context, state) {
        //       return const clovaPage();
        //     }),
        //     routes: [
        //       GoRoute(
        //         path: 'EditReceiptPage/:modifyFlag',
        //         builder: (context, state) {
        //           ReceiptContent content = state.extra as ReceiptContent;
        //           return EditReceiptPage(
        //             receiptContent: content,
        //             modifyFlag: state.pathParameters["modifyFlag"]!,
        //           );
        //         },
        //       ),
        //     ]),
        // GoRoute(
        //   path: "SettlementPage/:settlementId",
        //   builder: (context, state) {
        //     return SettlementPage(
        //       settlementId: state.pathParameters["settlementId"]!,
        //     );
        //   },
        //   routes: <RouteBase>[
        //     GoRoute(
        //       path: 'CompleteSettlementMatching',
        //       builder: (context, state) {
        //         return const CompleteSettlementMatching();
        //       },
        //     ),
        //   ],
        // ),
        // GoRoute(
        //     path: 'SettlementFinalCheckPage',
        //     builder: (context, state) {
        //       return const SettlementFinalCheckPage();
        //     }),
         GoRoute(
           path: "MyPage",
           builder: (context, state) {
             return const myPage();
           },
         ),
        // GoRoute(
        //   path: "NotificationPage",
        //   builder: (context, state) {
        //     return const notificationPage();
        //   },
        // ),
        // GoRoute(
        //   path: "cameraDetectPage",
        //   builder: (context, state) {
        //     CameraDescription camera = state.extra as CameraDescription;
        //     return cameraDetectPage(extra: camera);
        //   },
        // ),
        // GoRoute(
        //   path: "scanedRecieptPage",
        //   builder: (context, state) {
        //     ReceiptContent content = state.extra as ReceiptContent;
        //     return CheckScannedReceiptPge(
        //       receiptContent: content,
        //     );
        //   },
        // ),
        // GoRoute(
        //   path: "mp",
        //   builder: (context, state) {
        //     return MainPage();
        //   },
        // ),
        // GoRoute(
        //   path: "kakaoPage",
        //   builder: (context, state) {
        //     return kakaoLoginPage();
        //   },
        // )
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
  // KakaoSdk 초기화
  // final nativeKey = await File("./Kakao/kakaoKey.txt").readAsString();
  // final jsKey = await File("./Kakao/kakaoJsKey.txt").readAsString();
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
      nativeAppKey: '00b83bf69fba554145c773d6737772fc',
      javaScriptAppKey: 'aa3a51d84f03c87a103a1a127dfcd8f9');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotificaiton);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _router.push(message.data["route"]);
  });
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      _router.push(message.data["route"]);
    }
  });
  if(!kIsWeb) {
    await initializeNotification();
  }
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

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  ServiceUser me = ServiceUser();
  void _getMyDeviceToken(ServiceUser user) async {
    final token = await FirebaseMessaging.instance.getToken();
    // print("내 디바이스 토큰: $token");
    user.fcmToken = token;
    user.tokenTimestamp = Timestamp.now();
    FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
  }

  Future<void> _checkToken(String userid) async {
    ServiceUser user = await ServiceUser().getUserByUserId(userid);
    ref.watch(userProvider).settingUserData(user);
    var nowtime = DateTime.now().millisecondsSinceEpoch;
    //DateTime prevtime = DateTime.parse(user.tokenTimestamp!.toDate().toString());
    if (user.fcmToken == "") {
      _getMyDeviceToken(user);
    } else if ((nowtime -
                DateTime.parse(user.tokenTimestamp!.toDate().toString())
                    .millisecondsSinceEpoch) /
            (1000 * 60 * 60 * 24) >=
        28) {
      _getMyDeviceToken(user);
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    // 사용하고 싶은 유저의 userId
    _checkToken("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb");
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
