import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_receiptitem.dart';
import 'package:groupsettlement2/viewmodel/shared_data.dart';
import '../class/class_group.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';
import '../class/class_alarm.dart';
import '../class/class_receipt.dart';
import '../common_fireservice.dart';

final userProvider = ChangeNotifierProvider<UserViewModel>(
        (ref) {
          return UserViewModel();
        });

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
  Map<Settlement, List<SettlementPaper>> settlementInfo = {};
  bool isFetchFinished = false;
  bool lock = true;
  int initialStmCount = 2;
  // String testString = "";

  UserViewModel();

  // void masterProviderTest(){
  //   provider.valueChangeTest("jytcjc");
  //   testString = provider.testString;
  //   notifyListeners();
  // }

  Future<void> settingUserData(ServiceUser me) async {
    userData = me;
    myGroup = [];
    settlementInfo = {};
    lock = true;
    isFetchFinished = false;
    fetchUser(userData.serviceUserId!);
    fetchSettlement(0, initialStmCount);
    return;
  }

  void sortSettlementInfo() {
    settlementInfo = Map.fromEntries(settlementInfo.entries.toList()
      ..sort((e1, e2) => e2.key.time!.compareTo(e1.key.time!)));
  }

  Future<int> fetchUser(String userId) async {
    userData = await ServiceUser().getUserByUserId(userId);
    fetchReceipt(userData.savedReceipts);
    fetchGroup(userData);
    notifyListeners();
    return 1;
  }

  Future<int> fetchGroup(ServiceUser me) async {
    userData = me;
    myGroup = [];
    for(var groupId in userData.groups){
      print(groupId);
      myGroup.add(await Group().getGroupByGroupId(groupId));
    }
    notifyListeners();
    return 1;
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
    // await fetchUser(userData.serviceUserId!);
    userData = await ServiceUser().getUserByUserId(userData.serviceUserId!);
    await fetchReceipt(userData.savedReceipts);
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
    // await fetchUser(userData.serviceUserId!);
    userData = await ServiceUser().getUserByUserId(userData.serviceUserId!);
    await fetchReceipt(userData.savedReceipts);
    return 1;
  }

  Future<void> fetchSettlement(int currentCount, int num) async {

    if (isFetchFinished == false) {
      print(1);
      for (int i = currentCount; i < currentCount + num; i++) {
        print(2);
        print(userData.settlements.length);
        if (i >= userData.settlements.length) {
          isFetchFinished = true;
          break;
        }
        print(3);
        Settlement stm = await Settlement().getSettlementBySettlementId(
            userData.settlements[userData.settlements.length - (i + 1)]);
        settlementInfo[stm] = [];
        print(4);
        await fetchStmPaper(stm);
      }
    }
    notifyListeners();
    return;
  }

  Future<void> fetchStmPaper(Settlement settlement) async {
    await Future.forEach(settlement.settlementPapers.values, (value) async {
      settlementInfo[settlement]!
          .add(await SettlementPaper().getSettlementPaperByPaperId(value));
    });
    return;
  }

  Future<int> fetchReceipt(List<String> rcpIds) async {
    myReceipts = [];
    if(rcpIds.isNotEmpty) {
      for(var rcpid in rcpIds){
        Receipt rcp = await Receipt().getReceiptByReceiptId(rcpid);
        ReceiptItem rcpi = await ReceiptItem().getReceiptItemByReceiptItemId(rcp.receiptItems[0]);
        firstReceiptItemName[rcp.receiptId ?? "X"] = rcpi.menuName ?? "뭘먹었을까";
        myReceipts.add(rcp);
      }
      notifyListeners();
    }
    return 1;
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

  void toggleLock() {
    lock = !lock;
    notifyListeners();
  }

  double getCurrentMoney(Settlement settlement) {
    double currentMoney = 0;

    settlementInfo[settlement]!.forEach((paper) {
      if (settlement.checkSent[paper.serviceUserId] == 3) {
        currentMoney = currentMoney + paper.totalPrice!;
      }
    });

    return currentMoney;
  }

  double getTotalPrice(Settlement settlement) {
    double totalPrice = 0;
    settlementInfo[settlement]!.forEach((paper) {
      totalPrice = totalPrice + paper.totalPrice!;
    });
    return totalPrice;
  }

  double getSendMoney(Settlement settlement) {
    for (SettlementPaper paper in settlementInfo[settlement]!) {
      if (paper.serviceUserId == userData.serviceUserId) {
        return paper.totalPrice!;
      }
    }
    return -1;
  }

  String getGroupName(Settlement settlement) {
    String name = "null";
    myGroup.forEach((group) {
      if (group.groupId == settlement.groupId) {
        name = group.groupName!;
      }
    });
    return name;
  }

}




