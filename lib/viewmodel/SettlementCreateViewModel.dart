import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_receipt.dart';
import '../class/class_group.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';
import '../clova/clova.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;
final stmCreateProvider = ChangeNotifierProvider<SettlementCreateViewModel>(
    (ref) => SettlementCreateViewModel());

class SettlementCreateViewModel extends ChangeNotifier {
  Clova clova = Clova();
  Group myGroup = Group();
  Receipt newReceipt = Receipt();
  ServiceUser userData = ServiceUser();
  Settlement settlement = Settlement();
  List<ReceiptItem> newReceiptItems = <ReceiptItem>[];
  Map<String, Receipt> receipts = <String, Receipt>{};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>>{};

  SettlementCreateViewModel();

  Future<void> settingSettlementCreateViewModel(
      Group group, ServiceUser me) async {
    receipts = {};
    receiptItems = {};
    myGroup = group;
    userData = me;

    settlement = Settlement();
    settlement.groupId = myGroup.groupId;
    settlement.masterUserId = userData.serviceUserId;
    settlement.accountInfo =
        userData.accountInfo.isNotEmpty ? userData.accountInfo[0] : "";

    for (var user in myGroup.serviceUsers) {
      if (user == settlement.masterUserId) {
        settlement.checkSent[user] = 3;
        continue;
      }
      settlement.checkSent[user] = 0;
    }
    notifyListeners();
    return;
  }

  void createReceiptFromNaverOCR(var json) {
    newReceipt = Receipt();
    newReceiptItems = [];
    notifyListeners();
    // => json 영수증 양식으로 변환하는 코드 필요
    try {
      newReceipt.storeName =
          json['images'][0]['receipt']['result']['storeInfo']['name']['text'];
    } catch (e) {
      newReceipt.storeName = "NotFound";
    }
    try {
      newReceipt.time = json['paymentInfo']['date']['text'] +
          " " +
          json['paymentInfo']['time']['text'];
    } catch (e) {
      newReceipt.time = null;
    }

    for (var item in json['images'][0]['receipt']['result']['subResults'][0]
        ['items']) {
      ReceiptItem rcpitem = ReceiptItem();
      rcpitem.menuName = item['name']['text'];
      try {
        rcpitem.menuCount = int.parse(item['count']['text']);
      } catch (e) {
        rcpitem.menuCount = -1;
      }

      try {
        rcpitem.menuPrice =
            int.parse(item['price']['price']['formatted']['value']);
      } catch (e) {
        try {
          rcpitem.menuPrice =
              int.parse(item['price']['price']['formatted']['value']);
        } catch (e) {
          rcpitem.menuPrice = -1000;
        }
      }
      newReceiptItems.add(rcpitem);
    }
    try {
      newReceipt.totalPrice = int.parse(json['images'][0]['receipt']['result']
          ['totalPrice']['price']['formatted']['value']);
    } catch (e) {
      newReceipt.totalPrice = -1000;
    }
    notifyListeners();
  }


  void completeEditReceipt(String receiptId) {
    if (receipts.containsKey(newReceipt.receiptId!)) {
      receipts[newReceipt.receiptId!] = newReceipt;
      receiptItems[newReceipt.receiptId!] = newReceiptItems;
    }
    notifyListeners();
  }


  // 영수증/영수증항목 뷰모델에 추가하기
  void addReceipt() {
    newReceipt.settlementId = settlement.settlementId;
    newReceipt.receiptItems = [];
    for (var newReceiptItem in newReceiptItems) {
      newReceipt.receiptItems.add(newReceiptItem.receiptItemId!);
    }
    settlement.receipts.add(newReceipt.receiptId!);
    receipts[newReceipt.receiptId!] = newReceipt;
    receiptItems[newReceipt.receiptId!] = newReceiptItems;
    settlement.totalPrice += newReceipt.totalPrice;
    notifyListeners();
  }

  // 영수증 삭제하기
  void deleteReceipt(String receiptId) {
    settlement.receipts.remove(receiptId);
    receiptItems.remove(receiptId);
    receipts.remove(receiptId);
    notifyListeners();
  }

  // 5. 정산 최종 생성하기, DB 접근이 이루어지는 시점
  Future<String> createSettlement(String stmname) async {
    settlement.settlementName = stmname;
    final groupRef = db.collection("grouplist").doc(myGroup.groupId);
    List<DocumentReference<Map<String, dynamic>>> userRefs = [];
    List<ServiceUser> users = [];

    var res = await db.runTransaction((transaction) async {
      myGroup.settlements.add(settlement.settlementId!);
      await Future.forEach(myGroup.serviceUsers, (userid) async {
        final userRef = db.collection("userlist").doc(userid);
        userRefs.add(userRef);
        final snapshot = await transaction.get(userRef); //transaction을 거친 문서 읽어오기
        ServiceUser user = ServiceUser.fromSnapShot(snapshot); //snapshot(json)형태를 model 형식에 맞게 파싱
        user.settlements.add(settlement.settlementId!);
        users.add(user);
      });

      await Future.forEach(receipts.entries, (receipt) async {
        receipt.value.createReceipt();
      });

      await Future.forEach(receiptItems.entries, (receiptitems) async {
        await Future.forEach(receiptitems.value, (item) async {
          item.createReceiptItem();
        });
      });

      int i = 0;
      await Future.forEach(userRefs, (userRef) async {
        transaction.update(userRef, users[i++].toJson());
      });

      transaction.update(groupRef, myGroup.toJson());
      settlement.time = Timestamp.now();
      settlement.createSettlement();
      return settlement.settlementId;
    }).catchError((e) {
      print(e);
      return "error";
    });
    
    notifyListeners();
    return res!;
  }

}
