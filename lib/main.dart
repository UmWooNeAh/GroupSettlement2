import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/view/MainPage.dart';
import 'package:groupsettlement2/view/ryu_page.dart';
import 'package:groupsettlement2/view/sin_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'design_element.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

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
      alert: true,
      badge: true,
      sound: true
  );
}


final firstProvider = Provider((_) => 'Hello World');
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder:  (context, state){return const SplashView();},
      routes: <RouteBase>[
        GoRoute(path: 'MainPage', builder: (context, state){return const MainPage();}),
        GoRoute(path: 'RyuPage', builder: (context, state){return const RyuPage();}),
        GoRoute(path: 'SinPage', builder: (context, state){return const SinPage();}),
      ],
    ),
  ],
);


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // runApp() 호출 전 Flutter SDK 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotification();
  KakaoSdk.init(nativeAppKey: '',javaScriptAppKey: '');
  runApp(const ProviderScope(child: MyApp()),);
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
    if(user.fcmToken == null || (nowtime - user.tokenTimestamp!) / (1000*60*60*24*30) >= 28)
    {
      _getMyDeviceToken(user);
      FireService().updateDoc("userlist", userid, user.toJson());
    }
  }

  @override
  void initState(){
    super.initState();
    _getMyDeviceToken(me);
    // _checkToken(me.serviceUserId!);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if(notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'hight_importance_channel', 'high_importance_notification',
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
      (){
        context.go("/MainPage");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(child: Container(color: Colors.white,),),
        Center(child: Container(height: 100, width: 100, color: Colors.deepPurpleAccent),),
        Positioned(
          bottom: size.height * 0.6,
          child: Transform.rotate(
            angle: pi * 3 / 4,
            child: Container(height:size.width * 1.7, width: size.width, color: color1,),
          ),
        ),
        Positioned(
          top: size.height * 0.6,
          child: Transform.rotate(
            angle: pi * 3 / 4,
            child: Container(height:size.width * 1.7, width: size.width, color: color2,),
          ),
        ),
      ],
    );
  }
}