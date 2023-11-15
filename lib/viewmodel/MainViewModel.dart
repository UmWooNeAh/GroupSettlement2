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
  bool isFetchFinished = false;
  bool lock = true;
  int stmNum = 0;

  MainViewModel(String userId) {
    //settingMainViewModel(userId);
  }

  Future settingMainViewModel(String userId) async {
    myGroup = []; settlementInfo = {}; lock = true; isFetchFinished = false;
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


}




