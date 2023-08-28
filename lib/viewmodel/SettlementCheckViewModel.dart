
import '../class/class_settlement.dart';
import '../class/class_settlementpaper.dart';

class SettlementCheckViewModel{
  Settlement      settlement      = Settlement();
  SettlementPaper settlementPaper = SettlementPaper();

  SettlementCheckViewModel(String settlementId, String userId){
    _settingSettlementCheckViewModel(settlementId, userId);
  }

  void _settingSettlementCheckViewModel(String settlementId, String userId) async {

    settlement = await Settlement().getSettlementBySettlementId(settlementId);
    for(var paper in settlement.settlementPapers!.entries) {
      settlementPaper = await SettlementPaper().getSettlementPaperByPaperId(paper.value);
      if(settlementPaper.serviceUserId == userId) {
        break;
      }
    }

    /*for(int i = 0; i < settlement.settlementPapers!.length; i++){
      await settlementPaper.getSettlementPaperByPaperId(settlement.settlementPapers![i]);
      if(settlementPaper.serviceUserId == userId){
        break;
      }
    }
     */
  }

  void sendComplete(setttlementId, userId){
    settlement.checkSent![userId] = true;
    //settlement.updatesettlement();
  }

  void finishSettlement(){
    //settlement.isFinished = true;
    //settlement.updatesettlement();
  }
}