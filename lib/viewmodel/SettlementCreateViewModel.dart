import 'package:group_settlement/class/class_receipt.dart';
import '../class/class_group.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

class SettlementCreateViewModel {
  // 0. Settlement 생성에 필요한 객체들 선언
  String               groupId;
  Settlement           settlement = Settlement();
  Map<String, Receipt> receipts = <String, Receipt>{};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>>{};

  // 1. 정산생성 이후에만 나머지 창 을 들어갈 수 있으므로 처음 만들어질 때 객체를 새롭게 생성한다
  SettlementCreateViewModel(this.groupId) {
    _settingSettlementCreateViewModel();
  }

  // 1-1. Settlement 객체 생성
  void _settingSettlementCreateViewModel() {
    settlement.settlementId = "settlement_Id";
    // settlement.settlementName: "default_settlement_Name";
  }

  // 2. 영수증 추가하기
  void addReceipt(Receipt newReceipt, List<ReceiptItem> newReceiptItems){
    newReceipt.settlementId = settlement.settlementId;
    for(int i = 0; i < newReceiptItems.length; i++){
      newReceipt.receiptItems!.add(newReceiptItems[i].receiptItemId!);
    }
    receiptItems[newReceipt.receiptId!] = newReceiptItems;
    newReceipt.receiptId = "receiptId";
    settlement.receipts!.add(newReceipt.receiptId!);
    receipts[newReceipt.receiptId!] = newReceipt;
  }
  // Naver OCR
  Receipt receiptFromNaverOCR(){
    Receipt newReceipt = Receipt();
    return newReceipt;
  }

  // 3. 영수증 수정하기
  void editReceipt(Receipt edittedReceipt, List<ReceiptItem> edittedReceiptItems){
    receipts[edittedReceipt.receiptId!] = edittedReceipt;
    edittedReceipt.receiptItems!.clear();
    for(int i = 0; i < edittedReceiptItems.length; i++){
      edittedReceipt.receiptItems!.add(edittedReceiptItems[i].receiptItemId!);
    }
    receiptItems[edittedReceipt.receiptId!] = edittedReceiptItems;
  }

  // 4. 영수증 삭제하기
  void deleteReceipt(String receiptId){
    settlement.receipts!.remove(receiptId);
    receiptItems.remove(receiptId);
    receipts.remove(receiptId);
  }

  // 5. 정산 생성하기기
  void createSettlement() async {
    Group group = await Group().getGroupByGroupId(groupId);
    group.settlements!.add(settlement.settlementId!);
    // group_updatecode 들어가야함

    for(int i = 0; i < settlement.users!.length; i++){
      User user = await User().getUserByUserId(settlement.users![i]);
      user.settlements!.add(settlement.settlementId!);
      // user update코드 들어가야함
    }

    settlement.createSettlement();
  }

}