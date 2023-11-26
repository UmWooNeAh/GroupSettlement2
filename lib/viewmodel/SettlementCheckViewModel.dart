import 'package:cloud_firestore/cloud_firestore.dart';
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
final FirebaseFirestore db = FirebaseFirestore.instance;
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
  double completedPrice = 0;

  SettlementCheckViewModel();

  Future<int> settingSettlementCheckViewModel(
      Settlement rSettlement, Group rGroup, ServiceUser me) async {
    settlement = rSettlement;
    group = rGroup;
    userData = me;
    completedPrice = 0;
    notifyListeners();

    // settlementPaper, 이에딸린 settlementItem전부 가져오기
    settlement.settlementPapers.forEach((key, value) async {
      SettlementPaper stm =
          await SettlementPaper().getSettlementPaperByPaperId(value);
      settlementPapers[key] = stm;
      if (settlement.checkSent[stm.serviceUserId] == 3){
        completedPrice += stm.totalPrice ?? 0;
      }
      List<SettlementItem> items = [];
      for(var itemId in stm.settlementItems){
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
    final stmRef = db.collection("settlementlist").doc(settlement.settlementId);
    db.runTransaction((transaction) async {
      settlement.checkSent[userId] = 1;
      transaction.update(stmRef, settlement.toJson()); //transaction을 거친 문서 업데이트, 모델을 다시 json형태로 변환하여 db에 올려야함
    }).then(
          (value) {
        print("DocumentSnapshot successfully updated!"); //성공 메시지
      },
      onError: (e) => print("Error updating document $e"), //실패 메시지
    );
  }

  void requestSendAgain(String userId) {
    final stmRef = db.collection("settlementlist").doc(settlement.settlementId);
    db.runTransaction((transaction) async {
      settlement.checkSent[userId] = 2;
      transaction.update(stmRef, settlement.toJson()); //transaction을 거친 문서 업데이트, 모델을 다시 json형태로 변환하여 db에 올려야함
    }).then(
          (value) {
        print("DocumentSnapshot successfully updated!"); //성공 메시지
      },
      onError: (e) => print("Error updating document $e"), //실패 메시지
    );
  }

  void confirmSent(String userId) {
    final stmRef = db.collection("settlementlist").doc(settlement.settlementId);
    db.runTransaction((transaction) async {
      settlement.checkSent[userId] = 3;
      transaction.update(stmRef, settlement.toJson()); //transaction을 거친 문서 업데이트, 모델을 다시 json형태로 변환하여 db에 올려야함
    }).then(
          (value) {
        print("DocumentSnapshot successfully updated!"); //성공 메시지
      },
      onError: (e) => print("Error updating document $e"), //실패 메시지
    );
  }

  void finishSettlement() {
    final stmRef = db.collection("settlementlist").doc(settlement.settlementId);
    db.runTransaction((transaction) async {
      settlement.isFinished = true;
      transaction.update(stmRef, settlement.toJson());
    }).then(
          (value) {
        print("DocumentSnapshot successfully updated!"); //성공 메시지
      },
      onError: (e) => print("Error updating document $e"), //실패 메시지
    );
  }

}
