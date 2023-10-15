import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_group.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementitem.dart';
import '../class/class_settlementpaper.dart';
import '../class/class_user.dart';

final stmCheckProvider = ChangeNotifierProvider<SettlementCheckViewModel>(
        (ref) => SettlementCheckViewModel("54d974c2-ea2a-4998-89a3-6d9cca52db80",
        "88f8433b-0af1-44be-95be-608316118fad", "8dcca5ca-107c-4a12-9d12-f746e2e513b7"));

class SettlementCheckViewModel extends ChangeNotifier{
  Settlement                          settlement        = Settlement();
  String?                             groupName;
  String?                             masterName;
  Map<String, SettlementPaper>        settlementPapers  = <String, SettlementPaper> {};
  Map<String, List<SettlementItem>>   settlementItems   = <String, List<SettlementItem>> {};
  Map<String, Receipt>                receipts          = <String, Receipt> {};
  Map<String, List<ReceiptItem>>      receiptItems      = <String, List<ReceiptItem>> {};

  SettlementCheckViewModel(String settlementId, String groupname, String userId) {
    settlementPapers = {}; settlementItems = {}; receipts = {}; receiptItems = {};
    settingSettlementCheckViewModel(settlementId, groupname, userId);
  }

  void settingSettlementCheckViewModel(String settlementId, String groupname, String userId) async {
    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    groupName = groupname;
    ServiceUser muser = await ServiceUser().getUserByUserId(settlement.masterUserId!);
    masterName = muser.name;

    settlement.settlementPapers.forEach((key, value) async {
      SettlementPaper stm = await SettlementPaper().getSettlementPaperByPaperId(value);
      settlementPapers[key] = stm;
      List<SettlementItem> items = [];
      stm.settlementItems.forEach((itemid) async {
        SettlementItem item = await SettlementItem().getSettlementItemBySettlementItemId(itemid);
        items.add(item);
      });
      settlementItems[key] = items;
    });

    settlement.receipts.forEach((rcpid) async {
      Receipt receipt = await Receipt().getReceiptByReceiptId(rcpid);
      receipts[rcpid] = receipt;
      List<ReceiptItem> items = [];
      receipt.receiptItems.forEach((itemid) async {
        ReceiptItem item = await ReceiptItem().getReceiptItemByReceiptItemId(itemid);
        items.add(item);
      });
      receiptItems[rcpid] = items;
    });

    notifyListeners();
  }

  void requestCheckMySent(String userId) {
    settlement.checkSent[userId] = 1;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void requestSendAgain(String userId) {
    settlement.checkSent[userId] = 2;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void confirmSent(String userId) {
    settlement.checkSent[userId] = 3;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void finishSettlement() {
    settlement.isFinished = true;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }
}