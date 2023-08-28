import 'dart:ffi';

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

  void _settingSettlementViewModel(String settlementId) async{
    settlement.getSettlementBySettlementId(settlementId);
    for(int i = 0; i < settlement.receipts!.length; i++){
      // Settlement -> Receipt 하나씩 불러오기
      Receipt newReceipt = Receipt();
      receipts[settlement.receipts![i]] = await newReceipt.getReceiptByReceiptId(settlement.receipts![i]);
      for(int j = 0; j < receipts[settlement.receipts![i]]!.receiptItems!.length; j++){
        // Receipt -> ReceiptItem 하나씩 불러오기
        ReceiptItem newReceiptItem = ReceiptItem();
        receiptItems[receipts[settlement.receipts![i]]!.receiptItems![j]] =
            await newReceiptItem.getReceiptItemByReceiptItemId(receipts[settlement.receipts![i]]!.receiptItems![j]);
      }
    }
  }

  void addSettlementItem(String receiptItemId, String userId){
    // receiptItem이 선택이 됐었는지에 따라 userId를 추가해주기 + 처음 선택됐을 때 finalSettlement에 추가
    if(receiptItems[receiptItemId]!.users == null){
      receiptItems[receiptItemId]!.users = [userId];
      finalSettlement.add(receiptItemId);
    }
    else{
      receiptItems[receiptItemId]!.users!.add(userId);
    }

    _addItemToSettlementPaper(receiptItemId, userId);
    _updateSettlementItemPrice(receiptItemId);
  }

  void addSettlementItemBySubGroup(String receiptItemId, String subGroupId){
    if(receiptItems[receiptItemId]!.users == null){
      receiptItems[receiptItemId]!.users = subGroups[subGroupId];
      finalSettlement.add(receiptItemId);
    }
    else{
      receiptItems[receiptItemId]!.users!.addAll(subGroups[subGroupId]!);
    }

    for(int i = 0; i < subGroups[subGroupId]!.length; i++){
      _addItemToSettlementPaper(receiptItemId, subGroups[subGroupId]![i]);
    }
    _updateSettlementItemPrice(receiptItemId);
  }


  void deleteSettlementItem(String receiptItemId, String userId){
    _deleteItemToSettlementPaper(receiptItemId, userId);
    // ReceiptItem에 user삭제
    receiptItems[receiptItemId]!.users!.remove(userId);

    if(receiptItems[receiptItemId]!.users!.isEmpty){
      finalSettlement.remove(receiptItemId);
    }
    else{
      _updateSettlementItemPrice(receiptItemId);
    }

  }

  void deleteSettlementItemBySubGroup(String receiptItemId, String subGroupId){
    for(int i = 0; i < subGroups[subGroupId]!.length; i++){
      _deleteItemToSettlementPaper(receiptItemId, subGroups[subGroupId]![i]);
    }

    for(int i = 0; i < subGroups[subGroupId]!.length; i++){
      receiptItems[receiptItemId]!.users!.remove(subGroups[subGroupId]![i]);
    }

    if(receiptItems[receiptItemId]!.users!.isEmpty){
      finalSettlement.remove(receiptItemId);
    }
    else{
      _updateSettlementItemPrice(receiptItemId);
    }
  }

  void _addItemToSettlementPaper(String receiptItemId, String userId){
    // userId에 따른 SettlementPaper가 없었을 때 생성후 settlement에 등록
    if(!settlementPapers.containsKey(userId)){
      SettlementPaper newSettlementPaper = SettlementPaper(userId: userId);
      newSettlementPaper.settlementPaperId = "aflkwcufhknwefgawkebygavwieufvhanlwieuvfhalwieuh";
      settlementPapers[userId] = newSettlementPaper;

      if(settlement.settlementPapers == null){
        settlement.settlementPapers = [newSettlementPaper.settlementPaperId ?? "default_settlement_paper_id"];
      }
      else{
        settlement.settlementPapers!.add(newSettlementPaper.settlementPaperId ?? "default_settlement_paper_id");
      }
    }

    // 어떤 item의 등록은 반드시 settlementItem 객체를 생성하므로 settlementitem이 생성된다
    SettlementItem newSettlementItem = SettlementItem();
    newSettlementItem.receiptItemId    = "abwlejkfbalwjkebfajbefaw";
    newSettlementItem.settlementItemId = "afewawbfkawhebflajwebhlawhb";
    newSettlementItem.menuName         = receiptItems[receiptItemId]!.menuName;
    newSettlementItem.menuCount        = receiptItems[receiptItemId]!.users!.length;
    newSettlementItem.price            = (receiptItems[receiptItemId]!.menuPrice!.toDouble() / newSettlementItem.menuCount!.toDouble());

    if(settlementPapers[userId]!.settlementItems == null){
      settlementPapers[userId]!.settlementItems = [newSettlementItem.settlementItemId!];
    }
    else{
      settlementPapers[userId]!.settlementItems!.add(newSettlementItem.settlementItemId!);
    }
  }
  void _updateSettlementItemPrice(String receiptItemId){
    for(int i = 0; i < receiptItems[receiptItemId]!.users!.length; i++){
      for(int j = 0; j < settlementPapers[receiptItems[receiptItemId]!.users![i]]!.settlementItems!.length; j++){
        if(settlementItems[settlementPapers[receiptItems[receiptItemId]!.users![i]]!.settlementItems![j]]!.receiptItemId == receiptItemId){
          settlementItems[settlementPapers[receiptItems[receiptItemId]!.users![i]]!.settlementItems![j]]!.menuCount =
              receiptItems[receiptItemId]!.users!.length;
          settlementItems[settlementPapers[receiptItems[receiptItemId]!.users![i]]!.settlementItems![j]]!.price =
          (receiptItems[receiptItemId]!.menuPrice!.toDouble() / receiptItems[receiptItemId]!.users!.length.toDouble());
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
      for(int i = 0; i < settlement.settlementPapers!.length; i++){
        if(settlement.settlementPapers![i] == settlementPapers[userId]!.settlementPaperId){
          settlement.settlementPapers!.removeAt(i);
          break;
        }
      }
      settlementPapers[userId] = null;
      settlementPapers.remove(userId);
    }
  }

  void createSubGroup(userId1, userId2){
    String newSubGroupId = "alwjebflakwejbflawebf";
    subGroups[newSubGroupId] = [userId1, userId2];
  }

  void addUsertoSubGroup(String subGroupId, String userId){
    subGroups[subGroupId]!.add(userId);
  }

  void completeSettlement(){
    // settlement Update
    // SettlementPaper Update
    // SettlementItem Update
    // User Update
    // Receipt Update
    // ReceiptItem Update
  }

  void requestSettlement(){

  }
}