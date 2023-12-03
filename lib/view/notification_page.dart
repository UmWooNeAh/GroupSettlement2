import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:intl/intl.dart';

import '../class/class_alarm.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';
import '../common_fireservice.dart';
import '../design_element.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> with TickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;
  Color labelColor = color2;
  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 3, vsync: this,initialIndex: 0);
    scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(userProvider);
    var cp = ref.watch(tabbarProvider);
    tabController.addListener(() {
      if(tabController.indexIsChanging){
        cp.changeColor(tabController.index);
      }
    });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:size.height*0.1),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right:25),
              child: Icon(Icons.settings,)
            ),
            Padding(
              padding: const EdgeInsets.only(left:30),
              child: Text("알림",
                style:TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                )
              ),
            ),
            SizedBox(width:double.infinity,height:30),
            Column(
              children: <Widget>[
                TabBar(
                    controller: tabController,
                    labelColor: cp.color,
                    labelStyle: TextStyle(
                        fontSize:15,
                        fontWeight: FontWeight.w600
                    ),
                    unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w400
                    ),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width:3,color: cp.color),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: true,
                    tabs:<Widget>[
                      Container(
                        width:size.width*0.25,
                        child: Tab(
                          text: "보낼 정산",

                        ),
                      ),
                      Container(
                        width:size.width*0.25,
                        child: Tab(
                          text: "받을 정산",
                        ),
                      ),
                      Container(
                        width:size.width*0.25,
                        child: Tab(
                          text: "기타",
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height:size.height*0.68,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: List.generate(provider.sendStmAlarm.length,
                                    (index) => SingleChildScrollView(
                                      physics: PageScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          oneNotification(
                                            alarm: provider.sendStmAlarm[index],
                                            size: size,
                                          ),
                                          SizedBox(width:20),
                                          GestureDetector(
                                            onTap: ()async{
                                              await provider.deleteAlarm(1, provider.sendStmAlarm[index]);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: color1
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: List.generate(provider.receiveStmAlarm.length,
                                    (index) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          oneNotification(
                                            alarm: provider.receiveStmAlarm[index],
                                            size: size,
                                          ),
                                          SizedBox(width:20),
                                          GestureDetector(
                                            onTap: ()async{
                                              await provider.deleteAlarm(0, provider.receiveStmAlarm[index]);
                                            },
                                            child: Container(
                                                width:25, height:25,
                                                decoration: BoxDecoration(
                                                    color: color1
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: List.generate(provider.etcStmAlarm.length,
                                    (index) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          oneNotification(
                                            alarm: provider.etcStmAlarm[index],
                                            size: size,
                                          ),
                                          SizedBox(width:20),
                                          GestureDetector(
                                            onTap: ()async{
                                              await provider.deleteAlarm(2, provider.etcStmAlarm[index]);
                                            },
                                            child: Container(
                                                width:25, height:25,
                                                decoration: BoxDecoration(
                                                    color: color1
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

          ],
        ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: true,
      ),
    );
  }
}

class oneNotification extends ConsumerStatefulWidget {
  final Alarm alarm;
  final Size size;
  const oneNotification({Key? key, required this.alarm,required this.size}) : super(key: key);

  @override
  ConsumerState<oneNotification> createState() => _oneNotificationState();
}

class _oneNotificationState extends ConsumerState<oneNotification> {

  @override
  Widget build(BuildContext context) {

    final provider = ref.watch(userProvider);

    Color read = widget.alarm.isRead == true ? Colors.grey : Colors.black;
    DateTime dt = widget.alarm.time != null
        ? DateTime.parse(widget.alarm.time!.toDate().toString())
        : DateTime.utc(1000, 01, 01);
    String timeAgo;

    if(DateTime.now().month - dt.month > 0){
      timeAgo = (DateTime.now().month - dt.month).toString() + "달 전";
    } else if(DateTime.now().day - dt.day > 0){
      timeAgo = (DateTime.now().day - dt.day).toString() + "일 전";
    } else if(DateTime.now().hour - dt.hour > 0){
      timeAgo = (DateTime.now().hour - dt.hour).toString() + "시간 전";
    } else if(DateTime.now().minute - dt.minute > 0){
      timeAgo = (DateTime.now().minute - dt.minute).toString() + "분 전";
    } else {
      timeAgo = "방금";
    }

    return GestureDetector(
      onTap: ()async{
        print(widget.alarm.category);
        var extra = await provider.linkAlarm(widget.alarm);
        print(extra);
        context.push(widget.alarm.route!,extra: extra);

        if(widget.alarm.isRead == false) {
          widget.alarm.isRead = true;
        }
          await FireService().updateDoc("alarmlist/${provider.userData.serviceUserId}/myalarmlist", widget.alarm.alarmId!, widget.alarm.toJson());


      },
      child: Container(
        width: widget.size.width*0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.alarm.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: read,
                  ),
                ),
                Text(timeAgo.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: read,
                  ),
                )
              ],
            ),
            SizedBox(height:5),
            Container(
              height:widget.size.height*0.03,
              child: Text(widget.alarm.body == null ? "\n" : widget.alarm.body!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  color: read,
                ),
              ),
            ),
            SizedBox(height:10),
            Divider()
          ]
        ),
      ),
    );
  }
}
final tabbarProvider = ChangeNotifierProvider<TabBarProvider>(
        (ref) => TabBarProvider());


class TabBarProvider extends ChangeNotifier {
  Color color = color1;
  TabBarProvider();

  void changeColor(int index){
    if(index == 0){
      color = color2;
    } else if(index == 1){
      color = color1;
    } else{
      color = Colors.grey;
    }
    notifyListeners();
  }

}
