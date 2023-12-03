import 'package:groupsettlement2/class/class_user.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';

SharedData sharedData = SharedData();
class SharedData {
  ServiceUser? me;
  Receipt? newReceipt;
  List<ReceiptItem> newReceiptItems = <ReceiptItem>[];

  Future<void> fetchUserData(String userId) async {
    me = await ServiceUser().getUserByUserId(userId);
    return;
  }

  void createNewReceipt(Receipt receipt, List<ReceiptItem> receiptItems){
    newReceipt = receipt;
    newReceiptItems = receiptItems;
    print(newReceiptItems);
  }
}
