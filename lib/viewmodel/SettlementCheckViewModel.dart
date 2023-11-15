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
    (ref) => SettlementCheckViewModel());

class SettlementCheckViewModel extends ChangeNotifier {
  ServiceUser userData = ServiceUser();
  Settlement settlement = Settlement();
  Group group = Group();
  String? masterName;
  Map<String, SettlementPaper> settlementPapers = <String, SettlementPaper>{};
  Map<String, List<SettlementItem>> settlementItems =
      <String, List<SettlementItem>>{};
  Map<String, Receipt> receipts = <String, Receipt>{};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>>{};

  SettlementCheckViewModel();

  Future<int> settingSettlementCheckViewModel(
      Settlement rSettlement, Group rGroup, ServiceUser me) async {
    settlement = rSettlement;
    group = rGroup;
    userData = me;
    notifyListeners();
    // settlementPaper, 이에딸린 settlementItem전부 가져오기
    settlement.settlementPapers.forEach((key, value) async {
      SettlementPaper stm =
          await SettlementPaper().getSettlementPaperByPaperId(value);
      settlementPapers[key] = stm;
      List<SettlementItem> items = [];
      for(var itemId in stm.settlementItems){
        print(itemId);
        items.add(await SettlementItem().getSettlementItemBySettlementItemId(itemId));
      }
      settlementItems[key] = items;
    });

    // receipt, 이에딸린 receiptItem전부 가져오기
    for(var rcpid in settlement.receipts){
      Receipt receipt = await Receipt().getReceiptByReceiptId(rcpid);
      receipts[rcpid] = receipt;
      List<ReceiptItem> items = [];
      for(var itemId in receipt.receiptItems){
        ReceiptItem item = await ReceiptItem().getReceiptItemByReceiptItemId(itemId);
        items.add(item);
      }
      receiptItems[rcpid] = items;
    }

    notifyListeners();
    return 1;
  }

  void requestCheckMySent(String userId) {
    settlement.checkSent[userId] = 1;
    FireService().updateDoc(
        "settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void requestSendAgain(String userId) {
    settlement.checkSent[userId] = 2;
    FireService().updateDoc(
        "settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void confirmSent(String userId) {
    settlement.checkSent[userId] = 3;
    FireService().updateDoc(
        "settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void finishSettlement() {
    settlement.isFinished = true;
    FireService().updateDoc(
        "settlementlist", settlement.settlementId!, settlement.toJson());
  }
}
