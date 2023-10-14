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

final userProvider = ChangeNotifierProvider<UserViewModel>(
        (ref) => UserViewModel("8dcca5ca-107c-4a12-9d12-f746e2e513b7"));

class UserViewModel extends ChangeNotifier {

  ServiceUser userData = ServiceUser();
  List<Group> myGroup = <Group> [];
  List<Receipt> myReceipts = <Receipt> [];
  List<Settlement> mySettlements = <Settlement> [];
  List<SettlementPaper> mySettlementPapers = <SettlementPaper> [];
  List<bool> newAlarm = []; //0: 받을 정산 알림, 1: 보낼 정산 알림, 2: 기타 알림
  List<Alarm> receiveStmAlarm = <Alarm> [];
  List<Alarm> sendStmAlarm = <Alarm> [];
  List<Alarm> etcStmAlarm = <Alarm> [];

  UserViewModel(String userId) {
    settingUserViewModel(userId);
  }

  void settingUserViewModel(String userId) async {
    myGroup = []; myReceipts = []; mySettlements = []; mySettlementPapers = []; newAlarm = []; receiveStmAlarm = []; sendStmAlarm = []; etcStmAlarm = [];
    fetchUser(userId);
    fetchAlarm(userId);
  }

  void fetchUser(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
    notifyListeners();
    fetchReceipt(userData.savedReceipts);
    fetchGroup(userData.serviceUserId!);
  }

  void fetchGroup(String userId) async {
    List<Group> groups = await Group().getGroupList();
    for(var group in groups) {
        for(var user in group.serviceUsers) {
          if(user == userId){
            //Group Fetch
            myGroup.add(group);
            fetchSettlement(group);
          }
      }
    }
    notifyListeners();
  }

  void fetchSettlement(Group group) async {

    group.settlements.forEach((stmid) async {
      Settlement stm = await Settlement().getSettlementBySettlementId(stmid);
      mySettlements.add(stm);
      fetchStmPaper(stm);
    });
    notifyListeners();
  }

  void fetchStmPaper(Settlement settlement) async {

    settlement.settlementPapers.forEach((key, value) async {
      //SettlementPaper Fetch
      SettlementPaper temp = await SettlementPaper().getSettlementPaperByPaperId(value);
      mySettlementPapers.add(temp);
    });
    notifyListeners();
  }

  void fetchReceipt(List<String> rcpIds) async {

    if(rcpIds.length > 0) {
      rcpIds.forEach((rcpid) async {
        Receipt rcp = await Receipt().getReceiptByReceiptId(rcpid);
        myReceipts.add(rcp);
      });
      notifyListeners();
    }
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




