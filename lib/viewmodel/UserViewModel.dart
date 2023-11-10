import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_receiptitem.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';
import '../class/class_alarm.dart';
import '../class/class_receipt.dart';
import '../common_fireservice.dart';

final userProvider = ChangeNotifierProvider<UserViewModel>(
        (ref) => UserViewModel("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb"));

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
  Map<String, String> firstReceiptItemName = <String, String>{};

  UserViewModel(String userId) {}

  Future settingUserViewModel(String userId) async {
    myGroup = []; myReceipts = []; mySettlements = []; mySettlementPapers = []; newAlarm = []; receiveStmAlarm = []; sendStmAlarm = []; etcStmAlarm = [];
    fetchUser(userId);
    //fetchAlarm(userId);
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

  Future<int> createSavedReceipt() async{
    Receipt newSavedReceipt = Receipt();
    newSavedReceipt.totalPrice = 15000;
    for(int i = 0; i < 3; i++){
      ReceiptItem newSavedReceiptItem = ReceiptItem();
      newSavedReceipt.receiptItems.add(newSavedReceiptItem.receiptItemId!);
      newSavedReceiptItem.menuName = "테스트메뉴";
      newSavedReceiptItem.menuPrice = 5000;
      await newSavedReceiptItem.createReceiptItem();
    }
    await newSavedReceipt.createReceipt();
    userData.savedReceipts.add(newSavedReceipt.receiptId!);
    await FireService().updateDoc("userlist", userData.serviceUserId!, userData.toJson());
    await settingUserViewModel(userData.serviceUserId!);
    return 1;
  }

  Future<int> deleteSavedReceipt(String myReceiptId)async{
    Receipt myReceipt = Receipt();
    for (int i = 0; i < myReceipts.length; i++){
      if (myReceipts[i].receiptId == myReceiptId){
        myReceipt = myReceipts[i];
        break;
      }
    }
    for (int i = 0; i < myReceipt.receiptItems.length; i++){
      await FireService().deleteDoc("receiptitemlist", myReceipt.receiptItems[i]);
    }
    await FireService().deleteDoc("receiptlist", myReceiptId);
    userData.savedReceipts.remove(myReceiptId);
    await FireService().updateDoc("userlist", userData.serviceUserId!, userData.toJson());
    await settingUserViewModel(userData.serviceUserId!);
    // receiptId를 이용해서 receipt를 삭제 후 user정보 업데이트
    return 1;
  }

  void fetchSettlement(Group group) async {

    group.settlements.forEach((stmid) async {
      Settlement stm = await Settlement().getSettlementBySettlementId(stmid);
      mySettlements.add(stm);
      try {
        fetchStmPaper(stm);
      }catch(e){
        print("error!!!!! ${e}");
      }
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
    print("recipt loading num${rcpIds.length}");

    if(rcpIds.isNotEmpty) {
      rcpIds.forEach((rcpid) async {
        Receipt rcp = await Receipt().getReceiptByReceiptId(rcpid);
        ReceiptItem rcpi = await ReceiptItem().getReceiptItemByReceiptItemId(rcp.receiptItems[0]);
        firstReceiptItemName[rcp.receiptId ?? "X"] = rcpi.menuName ?? "뭘먹었을까";
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

  void addAccount(String bank, String accountNum, String holder) async {
    String fullInfo = bank + " " + accountNum + " " + holder;
    userData.accountInfo.add(fullInfo);
    FireService().updateDoc("userlist", userData.serviceUserId!, userData.toJson());
  }

  void deleteAccount(int index) async {
    userData.accountInfo.removeAt(index);
    FireService().updateDoc("userlist", userData.serviceUserId!, userData.toJson());
  }

}




