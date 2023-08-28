import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptItem {

  String? receiptItemId;
  List<String>? serviceUsers;
  String? menuName;
  int? menuCount;
  int? menuPrice;

  ReceiptItem({
    this.receiptItemId,
    this.serviceUsers,
    this.menuName,
    this.menuCount,
    this.menuPrice
  });

  ReceiptItem.fromJson(dynamic json) {
    receiptItemId = json['receiptitemid'];
    serviceUsers = List<String>.from(json["serviceusers"]);
    menuName = json['menuname'];
    menuCount = json['menucount'];
    menuPrice = json['menuprice'];
  }

  Map<String, dynamic> toJson() => {
    'receiptitemid' :receiptItemId,
    'serviceusers' : serviceUsers,
    'menuname' : menuName,
    'menucount' : menuCount,
    'menuprice' : menuPrice,
  };

  void createReceiptItem() async {
    await FirebaseFirestore.instance.collection("receiptitemlist").doc(receiptItemId).set(toJson());
  }
  
  Future<List<ReceiptItem>> getReceiptItemList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("receiptitemlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<ReceiptItem> receiptitems = [];
    for(var doc in querySnapshot.docs) {
      ReceiptItem item = ReceiptItem.fromQuerySnapshot(doc);
      receiptitems.add(item);
    }
    return receiptitems;
  }

  Future<ReceiptItem> getReceiptItemByReceiptItemId(String receiptitemid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("receiptitemlist").doc(receiptitemid).get();
    ReceiptItem item = ReceiptItem.fromSnapShot(result);
    return item;
  }

  ReceiptItem.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  ReceiptItem.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());
}