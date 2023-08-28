import 'package:cloud_firestore/cloud_firestore.dart';

class Settlement {

  String? settlementId;
  String? accountInfo;
  List<String>? receipts;
  Map<String, String>? settlementPapers;
  List<String>? serviceUsers;
  Map<String, bool>? checkSent;
  bool? isFinished;

  Settlement({
    this.settlementId,
    this.accountInfo,
    this.receipts,
    this.settlementPapers,
    this.serviceUsers,
    this.checkSent,
    this.isFinished,
  });

  Settlement.fromJson(dynamic json) {
    settlementId = json['settlementid'];
    accountInfo = json['accountinfo'];
    receipts = List<String>.from(json["receipts"]);
    settlementPapers = Map<String, String>.from(json["settlementpapers"]);
    serviceUsers = List<String>.from(json["serviceusers"]);
    checkSent = Map<String, bool>.from(json['checksent']);
    isFinished = json['isfinished'];
  }

  Map<String, dynamic> toJson() => {
    'settlementid' : settlementId,
    'accountinfo' : accountInfo,
    'receipts' : receipts,
    'settlementpapers' : settlementPapers,
    'serviceusers' : serviceUsers,
    'checksent' : checkSent,
    'isfinished' : isFinished,
  };

  void createSettlement() async {
    await FirebaseFirestore.instance.collection("settlementlist").doc(settlementId).set(toJson());
  }

  Future<List<Settlement>> getSettlementList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("settlementlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<Settlement> settlements = [];
    for(var doc in querySnapshot.docs) {
      Settlement stment = Settlement.fromQuerySnapshot(doc);
      settlements.add(stment);
    }
    return settlements;
  }

  Future<Settlement> getSettlementBySettlementId(String settlemntid) async{
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("settlemntlist").doc(settlemntid).get();
    Settlement stment = Settlement.fromSnapShot(result);
    return stment;
  }

  Settlement.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Settlement.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}