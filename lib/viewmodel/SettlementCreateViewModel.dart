import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_receipt.dart';
import '../class/class_group.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

class SettlementCreateViewModel {
  // 0. Settlement 생성에 필요한 객체들 선언
  Settlement           settlement = Settlement();
  Map<String, Receipt> receipts = <String, Receipt> {};
  Map<String, List<ReceiptItem>> receiptItems = <String, List<ReceiptItem>> {};

  // 1. 정산생성 이후에만 나머지 창 을 들어갈 수 있으므로 처음 만들어질 때 객체를 새롭게 생성한다
  SettlementCreateViewModel(String groupid, String masterid, String accountInfo) {
    settlement.groupId = groupid;
    settlement.masterUserId = masterid;
    settlement.accountInfo = accountInfo;
    _settingSettlementCreateViewModel();
  }

  // 1-1. Settlement 객체 생성(id 값이 미리 부여되어야함)
  void _settingSettlementCreateViewModel() {
    settlement.settlementId = "Random";
  }

  // 2. 영수증 추가하기
  void addReceipt(Receipt newReceipt, List<ReceiptItem> newReceiptItems){

    newReceipt.receiptId = "Random";
    newReceipt.settlementId = settlement.settlementId;
    for(var newReceiptItem in newReceiptItems){
      newReceipt.receiptItems.add(newReceiptItem.receiptItemId!);
    }

    settlement.receipts.add(newReceipt.receiptId!);
    receipts[newReceipt.receiptId!] = newReceipt;
    receiptItems[newReceipt.receiptId!] = newReceiptItems;
  }
  // Naver OCR
  Receipt receiptFromNaverOCR() {
    return Receipt();
  }

  // 3. 영수증 수정하기를 누르고 타이핑하여 수정한 내용을 반영
  void editReceipt(Receipt edittedReceipt, List<ReceiptItem> edittedReceiptItems) {

    receipts[edittedReceipt.receiptId!] = edittedReceipt;
    /*edittedReceipt.receiptItems!.clear();

    for(var item in edittedReceiptItems) {
      edittedReceipt.receiptItems!.add(item.receiptItemId!);
    }
     */
    receiptItems[edittedReceipt.receiptId!] = edittedReceiptItems;
  }

  // 4. 영수증 삭제하기
  void deleteReceipt(String receiptId){
    settlement.receipts.remove(receiptId);
    receiptItems.remove(receiptId);
    receipts.remove(receiptId);
  }

  // 5. 정산 최종 생성하기, DB 접근이 이루어지는 시점
  void createSettlement(String stmname) async {
    if(stmname == null) {
      print("정산명을 입력해주세요.");
    }
    else {
      settlement.settlementName = stmname;
      Group group = await Group().getGroupByGroupId(settlement.groupId!);
      group.settlements.add(settlement.settlementId!);
      FireService().updateDoc("grouplist", group.groupId!, group.toJson());
      // group_updatecode 들어가야함

      for(var userid in group.serviceUsers!) {
        ServiceUser user = await ServiceUser().getUserByUserId(userid);
        user.settlements.add(settlement.settlementId!);
        FireService().updateDoc("userlist", user.serviceUserId!, user.toJson());
        // user update코드 들어가야함
      }

      settlement.createSettlement();
    }

  }


}