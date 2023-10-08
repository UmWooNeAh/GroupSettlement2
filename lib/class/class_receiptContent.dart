import 'class_receipt.dart';
import 'class_receiptitem.dart';


class ReceiptContent {
  Receipt? receipt;
  List<ReceiptItem> receiptItems = <ReceiptItem> [];

  ReceiptContent (Receipt receipt, List<ReceiptItem> receiptitems) {
    this.receipt = receipt;
    this.receiptItems.addAll(receiptitems);
  }

}