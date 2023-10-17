import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeluuid.dart';

class Settlement {

  String? settlementId;
  String? masterUserId;
  String? groupId;
  String? settlementName;
  String? accountInfo;
  List<String> receipts = <String> [];
  Map<String, String> settlementPapers = <String, String> {};
  Map<String, int> checkSent = <String, int> {};
  bool? isFinished;
  bool? isMerged;
  List<String> mergedSettlement = <String> [];
  double totalPrice = 0;
  Timestamp? time;

  Settlement() {
    ModelUuid uuid = ModelUuid();
    settlementId = uuid.randomId;
    accountInfo = "";
    isFinished = false;
    isMerged = false;
  }

  Settlement.fromJson(dynamic json) {
    settlementId = json['settlementid'];
    masterUserId = json['masteruserid'];
    groupId = json['groupid'];
    settlementName = json['settlementname'];
    accountInfo = json['accountinfo'];
    receipts = List<String>.from(json["receipts"]);
    settlementPapers = Map<String, String>.from(json["settlementpapers"]);
    checkSent = Map<String, int>.from(json['checksent']);
    isFinished = json['isfinished'];
    isMerged = json['ismerged'];
    mergedSettlement= List<String>.from(json['mergedsettlement']);
    totalPrice = json['totalprice'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() => {
    'settlementid' : settlementId,
    'masteruserid' : masterUserId,
    'groupid' : groupId,
    'settlementname' : settlementName,
    'accountinfo' : accountInfo,
    'receipts' : receipts,
    'settlementpapers' : settlementPapers,
    'checksent' : checkSent,
    'isfinished' : isFinished,
    'ismerged' : isMerged,
    'mergedsettlement' : mergedSettlement,
    'totalprice' : totalPrice,
    'time' : time,
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

  Future<Settlement> getSettlementBySettlementId(String settlemntid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("settlementlist").doc(settlemntid).get();
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