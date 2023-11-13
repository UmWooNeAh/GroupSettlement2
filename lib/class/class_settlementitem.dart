import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeluuid.dart';


class SettlementItem {

  String? settlementItemId;
  String? receiptItemId;
  String? receiptId;
  String? menuName;
  int? menuCount;
  double? price;

  SettlementItem() {
    ModelUuid uuid = ModelUuid();
    settlementItemId = uuid.randomId;
  }

  SettlementItem.fromJson(dynamic json) {
    settlementItemId = json['settlementitemid'];
    receiptItemId = json['receiptitemid'];
    receiptId = json['receiptid'];
    menuCount = json['usercount'];
    menuName = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() => {
    'settlementitemid' : settlementItemId,
    'receiptitemid' : receiptItemId,
    'receiptid' : receiptId,
    'usercount' : menuCount,
    'name' : menuName,
    'price' : price,
  };

  void createSettlementItem() async {
    await FirebaseFirestore.instance.collection("settlementitemlist").doc(settlementItemId).set(toJson());
  }

  Future<List<SettlementItem>> getSettlementItemList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("settlementitemlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<SettlementItem> items = [];
    for(var doc in querySnapshot.docs) {
      SettlementItem item = SettlementItem.fromQuerySnapshot(doc);
      items.add(item);
    }
    return items;
  }

  Future<SettlementItem> getSettlementItemBySettlementItemId(String settlementitemid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("settlementitemlist").doc(settlementitemid).get();
    SettlementItem item = SettlementItem.fromSnapShot(result);
    return item;
  }

  SettlementItem.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  SettlementItem.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}