import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeluuid.dart';


class Receipt {
  String? receiptId;
  String? receiptName;
  String? settlementId;
  List<String> receiptItems = <String> [];
  String? storeName;
  Timestamp? time;
  int totalPrice = 0;

  Receipt() {
    ModelUuid uuid = ModelUuid();
    storeName = "";
    receiptId = uuid.randomId;
  }

  Receipt.fromJson(dynamic json) {
    receiptId = json['receiptid'];
    receiptName = json['receiptname'];
    settlementId = json['settlementid'];
    receiptItems = List<String>.from(json["receiptitems"]);
    storeName = json['storename'];
    time = json['time'];
    totalPrice = json['totalprice'];
  }

  Map<String, dynamic> toJson() => {
    'receiptid' : receiptId,
    'receiptname' : receiptName,
    'settlementid' : settlementId,
    'receiptitems' : receiptItems,
    'storename' : storeName,
    'time' : time,
    'totalprice' : totalPrice,
  };

  Future<int> createReceipt() async {
    await FirebaseFirestore.instance.collection("receiptlist").doc(receiptId).set(toJson());
    return 1;
  }

  Future<List<Receipt>> getReceiptList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("receiptlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<Receipt> receipts = [];
    for(var doc in querySnapshot.docs) {
      Receipt receipt = Receipt.fromQuerySnapshot(doc);
      receipts.add(receipt);
    }
    return receipts;
  }

  Future<Receipt> getReceiptByReceiptId(String receiptid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("receiptlist").doc(receiptid).get();
    Receipt receipt = Receipt.fromSnapShot(result);
    return receipt;
  }

  Receipt.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Receipt.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());
}