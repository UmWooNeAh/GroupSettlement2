import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';
import '../class/class_alarm.dart';
import '../class/class_receipt.dart';
import '../common_fireservice.dart';

final mainProvider = ChangeNotifierProvider<MainViewModel>(
        (ref) => MainViewModel("bxxwb8xp-p90w-ppfp-bbw9-b9bwwx8bf9bf"));

class MainViewModel extends ChangeNotifier {

  ServiceUser userData = ServiceUser();
  List<Group> myGroup = <Group> [];
  Map<Settlement,List<SettlementPaper>> settlementInfo = {};
  List<bool> newAlarm = []; //0: 받을 정산 알림, 1: 보낼 정산 알림, 2: 기타 알림
  List<Alarm> receiveStmAlarm = <Alarm> [];
  List<Alarm> sendStmAlarm = <Alarm> [];
  List<Alarm> etcStmAlarm = <Alarm> [];
  bool isFetchFinished = false;
  bool lock = true;
  int stmNum = 0;

  MainViewModel(String userId) {
    //settingMainViewModel(userId);
  }

  void stmPlus(){
    stmNum += 1;
    notifyListeners();
  }

  Future settingMainViewModel(String userId) async {
    myGroup = []; settlementInfo = {}; newAlarm = []; receiveStmAlarm = []; sendStmAlarm = []; etcStmAlarm = [];
    fetchUser(userId);
    //fetchAlarm(userId);
  }
  void sortSettlementInfo(){
    settlementInfo = Map.fromEntries(
        settlementInfo.entries.toList()..sort((e1,e2) => e2.key.time!.compareTo(e1.key.time!))
    );
  }
  void fetchUser(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
    notifyListeners();
    fetchGroup(userData.serviceUserId!);
  }

  void fetchGroup(String userId) async {
    List<Group> groups = await Group().getGroupList();
    for(var group in groups) {
      for(var user in group.serviceUsers) {
        if(user == userId){
          //Group Fetch
          myGroup.add(group);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchSettlement(int currentCount, int num) async {
    if(isFetchFinished == false) {
      for (int i = currentCount; i < currentCount + num; i++) {
        if (i >= userData.settlements.length) {
          isFetchFinished = true;
          break;
        }
        Settlement stm = await Settlement().getSettlementBySettlementId(
            userData.settlements[userData.settlements.length - (i + 1)]);
        settlementInfo[stm] = [];
        await fetchStmPaper(stm);
      }
    }
    notifyListeners();
    return;
  }

  Future<void> fetchStmPaper(Settlement settlement) async {
    await Future.forEach(settlement.settlementPapers.values, (value) async {
      settlementInfo[settlement]!.add(await SettlementPaper().getSettlementPaperByPaperId(value));
    });

    return;
  }

  void toggleLock(){
    lock = !lock;
    notifyListeners();
  }

  void fetchAlarm(String userId) async {
    List<Alarm> allalarmlist = await Alarm().getAlarmListByUserId(userId);
    classifyAlarm(allalarmlist);

    for(int i=0; i<3;i++) {
      newAlarm[i] = false;
    }
    notifyListeners();
  }

  void classifyAlarm(List<Alarm> allalarmlist) {

    for(var alarm in allalarmlist) {
      if(alarm.category == 0) {
        receiveStmAlarm.add(alarm);
      }
      else if(alarm.category == 1) {
        sendStmAlarm.add(alarm);
      }
      else if(alarm.category == 2) {
        etcStmAlarm.add(alarm);
      }
    }
    notifyListeners();
  }

  //해당 알림 클릭시 이동할 페이지 지정(미구현)
  void linkAlarm() {

  }

  double getCurrentMoney(Settlement settlement){
    double currentMoney = 0;
    settlementInfo[settlement]!.forEach((paper) {
      if (settlement.checkSent[paper.serviceUserId] == 2) {
        currentMoney = currentMoney + paper.totalPrice!;
      }
    });

    return currentMoney;
  }

  double getTotalPrice(Settlement settlement){
    double totalPrice = 0;
    settlementInfo[settlement]!.forEach((paper) {
      totalPrice = totalPrice + paper.totalPrice!;
    });
    return totalPrice;
  }

  double getSendMoney(Settlement settlement){


    for(SettlementPaper paper in settlementInfo[settlement]!){
      if(paper.serviceUserId == userData.serviceUserId){
        return paper.totalPrice!;
      }
    }

    return -1;
  }

  String getGroupName(Settlement settlement){
    String name = "null";
    myGroup.forEach((group){
      if(group.groupId == settlement.groupId) {
        name = group.groupName!;
      }
    });
    return name;
  }

  void deleteAlarm(int category, Alarm removeAlarm) async {

    if(category == 0) {
      receiveStmAlarm.remove(removeAlarm);
    }
    else if(category == 1) {
      sendStmAlarm.remove(removeAlarm);
    }
    else if(category == 2) {
      etcStmAlarm.remove(removeAlarm);
    }

    FireService().deleteDoc("alarmlist/" + userData.serviceUserId! + "/myalarmlist", removeAlarm.alarmId!);
    notifyListeners();
  }

}




