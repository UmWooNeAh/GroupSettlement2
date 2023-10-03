import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_receipt.dart';
import '../class/class_group.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

class SettlementCreateViewModel extends ChangeNotifier{
  // 0. Settlement 생성에 필요한 객체들 선언
  Settlement           settlement = Settlement();
  Map<String, Receipt> receipts = <String, Receipt> {};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>> {};

  // 1. 정산생성 이후에만 나머지 창 을 들어갈 수 있으므로 처음 만들어질 때 객체를 새롭게 생성한다
  SettlementCreateViewModel(String groupid, String masterid, String accountInfo) {
    _settingSettlementCreateViewModel(groupid, masterid, accountInfo);
  }

  // 1-1. Settlement 객체 생성
  void _settingSettlementCreateViewModel(String groupid, String masterid, String accountInfo) async{
    settlement.groupId = groupid;
    settlement.masterUserId = masterid;
    settlement.accountInfo = accountInfo;
    settlement.isFinished = false;

    Group group = await Group().getGroupByGroupId(groupid);
    for(var user in group.serviceUsers) {
        if(user == settlement.masterUserId) continue;
        settlement.checkSent[user] = 0;
      }
    notifyListeners();
  }

  // Naver OCR 영수증 인식
  void createReceiptFromNaverOCR(var json) {
    Receipt newReceipt = Receipt();
    List<ReceiptItem> newReceiptItems = [];
    // => json 영수증 양식으로 변환하는 코드 필요
    Map<String, dynamic> textReceipt = jsonDecode(json);
    newReceipt.storeName = textReceipt['storeInfo']['name']['text'];
    newReceipt.time = textReceipt['paymentInfo']['date']['text'] + " " + textReceipt['paymentInfo']['time']['text'];
    newReceipt.totalPrice = textReceipt['totalPrice']['price']['formantted']['value'] as int;

    for(var item in textReceipt['subResults']['items'])
    {
        ReceiptItem rcpitem = ReceiptItem();
        rcpitem.menuName = item['name']['text'];
        rcpitem.menuCount = item['count']['text'] as int;
        rcpitem.menuPrice = item['priceInfo']['price']['text'] as int;
        newReceiptItems.add(rcpitem);
    }
    addReceipt(newReceipt, newReceiptItems);
    notifyListeners();
  }
  //직접 추가
  void createReceiptFromTyping() {
    Receipt newReceipt = Receipt();
    List<ReceiptItem> newReceiptItems = [];
    addReceipt(newReceipt, newReceiptItems);
    notifyListeners();
  }

  // 영수증 뷰모델에 추가하기
  void addReceipt(Receipt newReceipt, List<ReceiptItem> newReceiptItems){

    newReceipt.settlementId = settlement.settlementId;
    if(receiptItems != null) {
      for (var newReceiptItem in newReceiptItems) {
        newReceipt.receiptItems.add(newReceiptItem.receiptItemId!);
      }
    }
    settlement.receipts.add(newReceipt.receiptId!);
    receipts[newReceipt.receiptId!] = newReceipt;
    receiptItems[newReceipt.receiptId!] = newReceiptItems;
    notifyListeners();
  }

  void editReceipt(int option, String receiptid, String originitemid, ReceiptItem item) {

    //영수증 항목 추가하기
    if(option == 1) {
      receipts[receiptid]!.receiptItems.add(item.receiptItemId!);
      receiptItems[receiptid]!.add(item);
    }
    //영수증 항목 편집하기
    else if(option == 2) {
      item.receiptItemId = originitemid;
      for(var rcpitem in receiptItems[receiptid!]!) {
        if(rcpitem.receiptItemId == item.receiptItemId) {
          rcpitem = item;
        }
      }
    }
    //영수증 항목 삭제하기
    else if(option == 3 ) {
      receipts[receiptid!]!.receiptItems.remove(item.receiptItemId!);
      receiptItems[receiptid!]!.remove(item);
    }
    /*
    receipts[edittedReceipt.receiptId!] = edittedReceipt;
    edittedReceipt.receiptItems!.clear();

    for(var item in edittedReceiptItems) {
      edittedReceipt.receiptItems!.add(item.receiptItemId!);
    }

    receiptItems[edittedReceipt.receiptId!] = edittedReceiptItems;
     */
    notifyListeners();
  }

  // 영수증 삭제하기
  void deleteReceipt(String receiptId){
    settlement.receipts.remove(receiptId);
    receiptItems.remove(receiptId);
    receipts.remove(receiptId);
    notifyListeners();
  }

  // 5. 정산 최종 생성하기, DB 접근이 이루어지는 시점
  void createSettlement(String stmname) async {
    if(stmname == null) {
      print("정산명을 입력해주세요.");
    }
    else {
      settlement.settlementName = stmname;
      Group group = await Group().getGroupByGroupId(settlement.groupId!);
      group.settlements.add(settlement.settlementId!);
      FireService().updateDoc("grouplist", group.groupId!, group.toJson());

      for(var userid in group.serviceUsers!) {
        ServiceUser user = await ServiceUser().getUserByUserId(userid);
        user.settlements.add(settlement.settlementId!);
        FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());

      for(var receipt in receipts.entries) {
          receipt.value.createReceipt();
      }
      for(var receiptitems in receiptItems.entries) {
        for(var item in receiptitems.value) {
            item.createReceiptItem();
        }
      }

      }
      settlement.createSettlement();
      notifyListeners();
    }
  }

}