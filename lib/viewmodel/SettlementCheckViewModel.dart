import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';

final stmCheckProvider = ChangeNotifierProvider<SettlementCheckViewModel>(
        (ref) => SettlementCheckViewModel("54d974c2-ea2a-4998-89a3-6d9cca52db80","8dcca5ca-107c-4a12-9d12-f746e2e513b7"));

class SettlementCheckViewModel extends ChangeNotifier{
  Settlement      settlement      = Settlement();
  SettlementPaper settlementPaper = SettlementPaper();

  SettlementCheckViewModel(String settlementId, String userId) {
    _settingSettlementCheckViewModel(settlementId, userId);
  }

  void _settingSettlementCheckViewModel(String settlementId, String userId) async {
    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    for(var paper in settlement.settlementPapers.entries) {
      SettlementPaper temp = await SettlementPaper().getSettlementPaperByPaperId(paper.value);
      if(settlementPaper.serviceUserId == userId) {
        settlementPaper = temp;
        break;
      }
    }
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