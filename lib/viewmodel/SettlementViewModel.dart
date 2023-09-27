import 'package:groupsettlement2/class/class_group.dart';
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
  List<String>                  settlementUsers = <String> [];
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
    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    Group group = await Group().getGroupByGroupId(settlement.groupId!);

    //정산자 제외하고 그룹의 유저 목록 불러오기
    for(var userid in group.serviceUsers) {
      if(userid == settlement.masterUserId) {
        continue;
      }
      settlementUsers.add(userid);
    }

    for(var receipt in settlement.receipts) {
      // Settlement -> Receipt 하나씩 불러오기
      Receipt newReceipt = await Receipt().getReceiptByReceiptId(receipt);
      receipts[receipt] = newReceipt;

      for(var receiptitem in receipts[receipt]!.receiptItems) {
        // Receipt -> ReceiptItem 하나씩 불러오기
        ReceiptItem newReceiptItem = await ReceiptItem().getReceiptItemByReceiptItemId(receiptitem);
        receiptItems[receiptitem] = newReceiptItem;
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
      receiptItems[receiptItemId]!.serviceUsers = subGroups[subGroupId]!;
      finalSettlement.add(receiptItemId);
    }
    else {
      receiptItems[receiptItemId]!.serviceUsers.addAll(subGroups[subGroupId]!);
    }

    for(var userid in subGroups[subGroupId]!) {
      _addItemToSettlementPaper(receiptItemId, userid);
    }
    _updateSettlementItemPrice(receiptItemId);
  }

  void deleteSettlementItem(String receiptItemId, String userId) {
    _deleteItemToSettlementPaper(receiptItemId, userId);
    // ReceiptItem에 매칭되어있는 user 삭제
    receiptItems[receiptItemId]!.serviceUsers.remove(userId);

    if(receiptItems[receiptItemId]!.serviceUsers.isEmpty) {
      finalSettlement.remove(receiptItemId);
    }
    else {
      _updateSettlementItemPrice(receiptItemId);
    }

  }

  void deleteSettlementItemBySubGroup(String receiptItemId, String subGroupId){

    for(var userid in subGroups[subGroupId]!) {
      _deleteItemToSettlementPaper(receiptItemId, userid);
    }

    for(var userid in subGroups[subGroupId]!) {
      receiptItems[receiptItemId]!.serviceUsers.remove(userid);
    }

    if(receiptItems[receiptItemId]!.serviceUsers.isEmpty) {
      finalSettlement.remove(receiptItemId);
    }
    else {
      _updateSettlementItemPrice(receiptItemId);
    }
  }

  void _addItemToSettlementPaper(String receiptItemId, String userId){
    // userId에 따른 SettlementPaper가 없었을 때 생성후 settlement에 등록
    if(!settlementPapers.containsKey(userId)) {
      SettlementPaper newSettlementPaper = SettlementPaper();
      newSettlementPaper.serviceUserId = userId;
      settlementPapers[userId] = newSettlementPaper;
      settlement.settlementPapers[userId] = newSettlementPaper.settlementPaperId!;
    }

    // item의 등록으로 인해 settlementItem 생성
    SettlementItem newSettlementItem = SettlementItem();
    newSettlementItem.receiptItemId    = receiptItemId;
    newSettlementItem.menuName         = receiptItems[receiptItemId]!.menuName;
    newSettlementItem.menuCount        = receiptItems[receiptItemId]!.serviceUsers.length;
    newSettlementItem.price            = (receiptItems[receiptItemId]!.menuPrice!.toDouble() / newSettlementItem.menuCount!.toDouble());

    if(settlementPapers[userId]!.settlementItems == null) {
      settlementPapers[userId]!.settlementItems = [newSettlementItem.settlementItemId!];
    }
    else {
      settlementPapers[userId]!.settlementItems!.add(newSettlementItem.settlementItemId!);
    }
  }

  void _updateSettlementItemPrice(String receiptItemId) {
    for(var userid in receiptItems[receiptItemId]!.serviceUsers) {
      for(var settlementitem in settlementPapers[userid]!.settlementItems) {
        if(settlementItems[settlementitem]!.receiptItemId == receiptItemId) {
          settlementItems[settlementitem]!.menuCount =
              receiptItems[receiptItemId]!.serviceUsers.length;
          settlementItems[settlementitem]!.price =
          (receiptItems[receiptItemId]!.menuPrice!.toDouble() / receiptItems[receiptItemId]!.serviceUsers.length.toDouble());
          break;
        }
      }
    }
  }

  void _deleteItemToSettlementPaper(String receiptItemId, String userId){
    // SettlementItem 삭제 paper에서 item 삭제, item객체 삭제, item map에서 삭제
    for(var settlementitem in settlementPapers[userId]!.settlementItems) {
      if(settlementItems[settlementitem]!.receiptItemId == receiptItemId){
        settlementPapers[userId]!.settlementItems.remove(settlementitem);
        settlementItems[settlementitem] = null;
        settlementItems.remove(settlementitem);
        break;
      }
    }
    // SettlementPaper가 할당받은 settlementItem이 없다면 settlementpaper 삭제
    if(settlementPapers[userId]!.settlementItems.isEmpty){
      for(var paper in settlement.settlementPapers.entries) {
        if(paper.value == settlementPapers[userId]!.settlementPaperId) {
          settlement.settlementPapers.remove(paper);
          break;
        }
      }

      settlementPapers[userId] = null;
      settlementPapers.remove(userId);
    }
  }

  void createSubGroup(String userId1, String userId2) {
    String newSubGroupId = "alwjebflakwejbflawebf";
    subGroups[newSubGroupId] = [userId1, userId2];
  }

  void addUserToSubGroup(String subGroupId, String userId) {
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
    // User Update(송금자만 업데이트)

    for(var userid in settlementUsers) {

      ServiceUser user = await ServiceUser().getUserByUserId(userid);
      for(var stmpaper in settlementPapers!.entries) {
        user.settlementPapers?.add(stmpaper.value!.settlementPaperId!);
      }
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

  void requestSettlement() async {

      for(var userid in settlementUsers) {

        ServiceUser user = await ServiceUser().getUserByUserId(userid);

        if(user.kakaoId == null) { //카카오톡 공유하기
            
        }
        else {//카카오 피커

        }
      }
  }
}