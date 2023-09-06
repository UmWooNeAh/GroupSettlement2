import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';

class SettlementCheckViewModel{
  Settlement      settlement      = Settlement();
  SettlementPaper settlementPaper = SettlementPaper();

  SettlementCheckViewModel(String settlementId, String userId) {
    _settingSettlementCheckViewModel(settlementId, userId);
  }

  void _settingSettlementCheckViewModel(String settlementId, String userId) async {

    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    for(var paper in settlement.settlementPapers.entries) {
      settlementPaper = await SettlementPaper().getSettlementPaperByPaperId(paper.value);
      if(settlementPaper.serviceUserId == userId) {
        break;
      }
    }
  }

  void sendComplete(String userId) {
    settlement.checkSent[userId] = true;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }

  void finishSettlement() {
    settlement.isFinished = true;
    FireService().updateDoc("settlementlist", settlement.settlementId!, settlement.toJson());
  }
}