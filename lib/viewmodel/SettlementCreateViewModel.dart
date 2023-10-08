import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_receipt.dart';
import '../class/class_group.dart';
import '../class/class_receiptContent.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';
import '../clova/clova.dart';

final stmCreateProvider = ChangeNotifierProvider<SettlementCreateViewModel>(
        (ref) => SettlementCreateViewModel("88f8433b-0af1-44be-95be-608316118fad","8dcca5ca-107c-4a12-9d12-f746e2e513b7",""));


class SettlementCreateViewModel extends ChangeNotifier{
  // 0. Settlement 생성에 필요한 객체들 선언
  Settlement                      settlement    = Settlement();
  Group                           myGroup       = Group();
  Map<String, Receipt>            receipts      = <String, Receipt> {};
  Map<String, List<ReceiptItem>>  receiptItems  = <String, List<ReceiptItem>> {};
  int                             totalPrice    = 0;
  Clova                           clova         = Clova();

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

    myGroup = await Group().getGroupByGroupId(groupid);
    for(var user in myGroup.serviceUsers) {
        if(user == settlement.masterUserId) continue;
        settlement.checkSent[user] = 0;
      }
    notifyListeners();
  }

  // Naver OCR 영수증 인식 후 Receipt/List<ReceiptItem> 리턴
  ReceiptContent createReceiptFromNaverOCR(String receiptName, var json) {
    Receipt newReceipt = Receipt();
    List<ReceiptItem> newReceiptItems = [];
    int tempTotalPrice = 0;
    newReceipt.receiptName = receiptName;
    // => json 영수증 양식으로 변환하는 코드 필요
    try {
      newReceipt.storeName =
      json['images'][0]['receipt']['result']['storeInfo']['name']['text'];
    }
    catch(e){ newReceipt.storeName = "NotFound";}
    try {
      newReceipt.time = json['paymentInfo']['date']['text'] + " " +
          json['paymentInfo']['time']['text'];
    }
    catch(e) {newReceipt.time = null;}

    for(var item in json['images'][0]['receipt']['result']['subResults'][0]['items'])
    {
        ReceiptItem rcpitem = ReceiptItem();
        rcpitem.menuName = item['name']['text'];
        try {
          rcpitem.menuCount = int.parse(item['count']['text']);
        } catch(e){
          rcpitem.menuCount = -1;
          print("Error occured processing count text : $e");
        }

        try {
          rcpitem.menuPrice =
              int.parse(item['price']['price']['formatted']['value']);
          tempTotalPrice += rcpitem.menuPrice!;
        }catch(e){
          rcpitem.menuPrice = -1;
          print("Error occured processing price text : $e");
        }
        newReceiptItems.add(rcpitem);
    }
    try {
      newReceipt.totalPrice = int.parse(
          json['images'][0]['receipt']['result']['totalPrice']['price']['formatted']['value']);
    }catch(e){ newReceipt.totalPrice = tempTotalPrice;}

    return ReceiptContent(newReceipt, newReceiptItems);
  }

  //직접 추가 후 Receipt/List<ReceiptItem> 리턴
  ReceiptContent createReceiptFromTyping(String receiptName, Receipt newReceipt, List<ReceiptItem> newReceiptItems) {
    return ReceiptContent(newReceipt, newReceiptItems);
  }

  // 영수증/영수증항목 뷰모델에 추가하기
  void addReceipt(ReceiptContent rcpContent){

    rcpContent.receipt!.settlementId = settlement.settlementId;
    if(receiptItems != null) {
      for (var newReceiptItem in rcpContent.receiptItems) {
        rcpContent.receipt!.receiptItems.add(newReceiptItem.receiptItemId!);
      }
    }
    settlement.receipts.add(rcpContent.receipt!.receiptId!);
    receipts[rcpContent.receipt!.receiptId!] = rcpContent.receipt!;
    receiptItems[rcpContent.receipt!.receiptId!] = rcpContent.receiptItems;
    totalPrice += rcpContent.receipt!.totalPrice;
    //log("영수증 항목 수: ${receiptItems[newReceipt.receiptId!]!.length}");
    notifyListeners();
  }

  //영수증 항목 추가하기
  void addReceiptItem(ReceiptContent rcpContent, ReceiptItem item) {
    rcpContent.receipt!.receiptItems.add(item.receiptItemId!);
    rcpContent.receiptItems.add(item);
  }

  //영수증 항목 편집하기
  void editReceiptItem(ReceiptContent rcpContent, ReceiptItem edittedItem, int index) {
    edittedItem.receiptItemId = rcpContent.receiptItems[index].receiptItemId;
    rcpContent.receiptItems[index] = edittedItem;
  }

  //영수증 항목 삭제하기
  void removeReceiptItem(ReceiptContent rcpContent, String rcpItemId, int index) {
    rcpContent.receipt!.receiptItems.remove(rcpItemId);
    rcpContent.receiptItems.removeAt(index);
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
      myGroup.settlements.add(settlement.settlementId!);
      FireService().updateDoc("grouplist", myGroup.groupId!, myGroup.toJson());

      for(var userid in myGroup.serviceUsers!) {
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