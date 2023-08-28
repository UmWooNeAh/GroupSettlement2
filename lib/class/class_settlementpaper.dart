import 'package:cloud_firestore/cloud_firestore.dart';

class SettlementPaper {

  String? settlementPaperId;
  String? settlementId;
  String? serviceUserId;
  String? accountInfo;
  List<String>? settlementItems;
  double? totalPrice;

  SettlementPaper({
    this.settlementPaperId,
    this.settlementId,
    this.serviceUserId,
    this.accountInfo,
    this.settlementItems,
    this.totalPrice
  });

  SettlementPaper.fromJson(dynamic json) {
    settlementPaperId = json['settlementpaperid'];
    settlementId = json['settlementid'];
    serviceUserId = json['serviceuserid'];
    accountInfo = json['accountinfo'];
    settlementItems = List<String>.from(json["settlementitems"]);
    totalPrice = json['totalprice'];
  }

  Map<String, dynamic> toJson() => {
    'settlementpaperid' : settlementPaperId,
    'settlementid' : settlementId,
    'serviceuserid' : serviceUserId,
    'accountinfo' : accountInfo,
    'settlementitems' : settlementItems,
    'totalprice' : totalPrice,
  };

  void createSettlementPaper() async {
    await FirebaseFirestore.instance.collection("settlementpaperlist").doc(this.settlementPaperId).set(toJson());
  }

  Future<List<SettlementPaper>> getSettlementPaperList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("settlementpaperlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<SettlementPaper> papers = [];
    for(var doc in querySnapshot.docs) {
      SettlementPaper paper = SettlementPaper.fromQuerySnapshot(doc);
      papers.add(paper);
    }
    return papers;
  }

  Future<SettlementPaper> getSettlementPaperByPaperId(String paperid) async{
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("settlemntpaperlist")
        .doc(paperid).get();
    SettlementPaper paper = SettlementPaper.fromSnapShot(result);
    return paper;
  }

  SettlementPaper.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  SettlementPaper.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());


}