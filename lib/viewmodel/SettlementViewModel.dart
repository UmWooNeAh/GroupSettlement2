import 'dart:ffi';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:groupsettlement2/common_fireservice.dart';

import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementitem.dart';
import '../class/class_settlementpaper.dart';

class SettlementViewModel{
  // Information
  Settlement                    settlement       = Settlement();
  Map<String, Receipt>          receipts         = <String, Receipt>{};
  Map<String, ReceiptItem>      receiptItems     = <String, ReceiptItem>{};

  // Management
  List<String>                  finalSettlement  = <String>[];
  Map<String, List<String>>     subGroups        = <String, List<String>>{};
  Map<String, SettlementPaper?> settlementPapers = <String, SettlementPaper?>{};
  Map<String, SettlementItem?>  settlementItems  = <String, SettlementItem?>{};

  SettlementViewModel(String settlementId){
    _settingSettlementViewModel(settlementId);
  }

  void _settingSettlementViewModel(String settlementId) async {
    settlement.getSettlementBySettlementId(settlementId);
    for(int i = 0; i < settlement.receipts!.length; i++) {
      // Settlement -> Receipt 하나씩 불러오기
      Receipt newReceipt = await Receipt().getReceiptByReceiptId(settlement.receipts![i]);
      receipts[settlement.receipts![i]] = newReceipt;

      for(int j = 0; j < receipts[settlement.receipts![i]]!.receiptItems!.length; j++) {
        // Receipt -> ReceiptItem 하나씩 불러오기
        ReceiptItem newReceiptItem = await ReceiptItem().getReceiptItemByReceiptItemId(
            receipts[settlement.receipts![i]]!.receiptItems![j]);
        receiptItems[receipts[settlement.receipts![i]]!.receiptItems![j]] = newReceiptItem;
      }
    }
  }

  void addSettlementItem(String receiptItemId, String userId) {
    // receiptItem이 선택이 되었는지에 따라 userId를 추가해주기 + 처음 선택됐을 때 finalSettlement에 추가
    if(receiptItems[receiptItemId]!.serviceUsers == null) {
      receiptItems[receiptItemId]!.serviceUsers = [userId];
      finalSettlement.add(receiptItemId);
    }
    else {
      receiptItems[receiptItemId]!.serviceUsers!.add(userId);
    }

    _addItemToSettlementPaper(receiptItemId, userId);
    _updateSettlementItemPrice(receiptItemId);
  }

  void addSettlementItemBySubGroup(String receiptItemId, String subGroupId) {
    if(receiptItems[receiptItemId]!.serviceUsers == null) {
      receiptItems[receiptItemId]!.serviceUsers = subGroups[subGroupId];
      finalSettlement.add(receiptItemId);
    }
    else {
      receiptItems[receiptItemId]!.serviceUsers!.addAll(subGroups[subGroupId]!);
    }

    for(int i = 0; i < subGroups[subGroupId]!.length; i++) {
      _addItemToSettlementPaper(receiptItemId, subGroups[subGroupId]![i]);
    }
    _updateSettlementItemPrice(receiptItemId);
  }


  void deleteSettlementItem(String receiptItemId, String userId) {
    _deleteItemToSettlementPaper(receiptItemId, userId);
    // ReceiptItem에 user 삭제
    receiptItems[receiptItemId]!.serviceUsers!.remove(userId);

    if(receiptItems[receiptItemId]!.serviceUsers!.isEmpty) {
      finalSettlement.remove(receiptItemId);
    }
    else {
      _updateSettlementItemPrice(receiptItemId);
    }

  }

  void deleteSettlementItemBySubGroup(String receiptItemId, String subGroupId){

    for(int i = 0; i < subGroups[subGroupId]!.length; i++) {
      _deleteItemToSettlementPaper(receiptItemId, subGroups[subGroupId]![i]);
    }

    for(int i = 0; i < subGroups[subGroupId]!.length; i++) {
      receiptItems[receiptItemId]!.serviceUsers!.remove(subGroups[subGroupId]![i]);
    }

    if(receiptItems[receiptItemId]!.serviceUsers!.isEmpty) {
      finalSettlement.remove(receiptItemId);
    }
    else {
      _updateSettlementItemPrice(receiptItemId);
    }
  }

  void _addItemToSettlementPaper(String receiptItemId, String userId){
    // userId에 따른 SettlementPaper가 없었을 때 생성후 settlement에 등록
    if(!settlementPapers.containsKey(userId)) {
      SettlementPaper newSettlementPaper = SettlementPaper(serviceUserId: userId);
      newSettlementPaper.settlementPaperId = "aflkwcufhknwefgawkebygavwieufvhanlwieuvfhalwieuh";
      settlementPapers[userId] = newSettlementPaper;

      /*if(settlement.settlementPapers == null){
        settlement.settlementPapers = [newSettlementPaper.settlementPaperId ?? "default_settlement_paper_id"];
      }
      else{
        settlement.settlementPapers![userId] = (newSettlementPaper.settlementPaperId ?? "default_settlement_paper_id");
      }*/

      settlement.settlementPapers![userId] = (newSettlementPaper.settlementPaperId ?? "default_settlement_paper_id");

    }

    // 어떤 item의 등록은 반드시 settlementItem 객체를 생성하므로 settlementitem이 생성된다
    SettlementItem newSettlementItem = SettlementItem();
    newSettlementItem.receiptItemId    = "abwlejkfbalwjkebfajbefaw";
    newSettlementItem.settlementItemId = "afewawbfkawhebflajwebhlawhb";
    newSettlementItem.menuName         = receiptItems[receiptItemId]!.menuName;
    newSettlementItem.menuCount        = receiptItems[receiptItemId]!.serviceUsers!.length;
    newSettlementItem.price            = (receiptItems[receiptItemId]!.menuPrice!.toDouble() / newSettlementItem.menuCount!.toDouble());

    if(settlementPapers[userId]!.settlementItems == null) {
      settlementPapers[userId]!.settlementItems = [newSettlementItem.settlementItemId!];
    }
    else {
      settlementPapers[userId]!.settlementItems!.add(newSettlementItem.settlementItemId!);
    }
  }

  void _updateSettlementItemPrice(String receiptItemId) {
    for(int i = 0; i < receiptItems[receiptItemId]!.serviceUsers!.length; i++) {
      for(int j = 0; j < settlementPapers[receiptItems[receiptItemId]!.serviceUsers![i]]!.settlementItems!.length; j++) {

        if(settlementItems[settlementPapers[receiptItems[receiptItemId]!.serviceUsers![i]]!.settlementItems![j]]!.receiptItemId == receiptItemId) {
          settlementItems[settlementPapers[receiptItems[receiptItemId]!.serviceUsers![i]]!.settlementItems![j]]!.menuCount =
              receiptItems[receiptItemId]!.serviceUsers!.length;
          settlementItems[settlementPapers[receiptItems[receiptItemId]!.serviceUsers![i]]!.settlementItems![j]]!.price =
          (receiptItems[receiptItemId]!.menuPrice!.toDouble() / receiptItems[receiptItemId]!.serviceUsers!.length.toDouble());
          break;
        }
      }
    }
  }
  void _deleteItemToSettlementPaper(String receiptItemId, String userId){
    // SettlementItem 삭제 paper에서 item 삭제, item객체 삭제, item map에서 삭제
    for(int i = 0; i < settlementPapers[userId]!.settlementItems!.length; i++){
      if(settlementItems[settlementPapers[userId]!.settlementItems![i]]!.receiptItemId == receiptItemId){
        settlementPapers[userId]!.settlementItems!.removeAt(i);
        settlementItems[settlementPapers[userId]!.settlementItems![i]] = null;
        settlementItems.remove(settlementPapers[userId]!.settlementItems![i]);
        break;
      }
    }
    // SettlementPaper가 할당받은 settlementItem이 없다면 settlementpaper 삭제
    if(settlementPapers[userId]!.settlementItems!.isEmpty){
      for(var paper in settlement.settlementPapers!.entries) {
        if(paper.value == settlementPapers[userId]!.settlementPaperId) {
          settlement.settlementPapers!.remove(paper.key);
          break;
        }
      }
      /*
      for(int i = 0; i < settlement.settlementPapers!.length; i++){
        if(settlement.settlementPapers![i] == settlementPapers[userId]!.settlementPaperId){
          settlement.settlementPapers!.removeAt(i);
          break;
        }
      }
       */
      settlementPapers[userId] = null;
      settlementPapers.remove(userId);
    }
  }

  void createSubGroup(userId1, userId2) {
    String newSubGroupId = "alwjebflakwejbflawebf";
    subGroups[newSubGroupId] = [userId1, userId2];
  }

  void addUsertoSubGroup(String subGroupId, String userId) {
    subGroups[subGroupId]!.add(userId);
  }

  void completeSettlement() async {
    // settlement Update
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
    // SettlementPaper Update
    for(var stmpaper in settlementPapers!.entries) {
      FireService().updateDoc("settlementpaperlist", stmpaper.key!, stmpaper.value!.toJson());
    }
    // SettlementItem Update
    for(var stmitem in settlementItems!.entries) {
      FireService().updateDoc("settlementpaperlist", stmitem.key!, stmitem.value!.toJson());
    }
    // User Update
    for(var userid in settlement.serviceUsers!) {

      ServiceUser user = await ServiceUser().getUserByUserId(userid);
      for(var stmpaper in settlementPapers!.entries) {
        user.settlementPapers?.add(stmpaper.value!.settlementPaperId!);
      }

      user.settlements?.add(settlement.settlementId!);
      FireService().updateDoc("userlist", userid, user.toJson());
    }
    // Receipt Update
    for(var rcp in receipts!.entries) {
      FireService().updateDoc("settlementpaperlist", rcp.key!, rcp.value!.toJson());
    }
    // ReceiptItem Update
    for(var rcpitem in receiptItems!.entries) {
      FireService().updateDoc("settlementpaperlist", rcpitem.key!, rcpitem.value!.toJson());
    }
  }

  void requestSettlement() {

  }
}