import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupsettlement2/class/class_user.dart';
import '../modeluuid.dart';

class SettlementPaper {

  String? settlementPaperId;
  String? settlementId;
  String? serviceUserId;
  String? userName;
  String? accountInfo;
  List<String> settlementItems = <String> [];
  List<String> sentSettlementItems = <String> [];
  double? totalPrice;
  bool? isMerged;
  double? discountedTotalPrice;

  SettlementPaper() {
    ModelUuid uuid = ModelUuid();
    totalPrice = 0;
    discountedTotalPrice = 0;
    settlementPaperId = uuid.randomId;
    isMerged = false;
  }

  SettlementPaper.fromJson(dynamic json) {
    settlementPaperId = json['settlementpaperid'];
    serviceUserId = json['serviceuserid'];
    settlementItems = List<String>.from(json["settlementitems"]);
    // sentSettlementItems = List<String>.from(json["sentsettlementitems"]);
    totalPrice = json['totalprice'];
    try{
      settlementId = json['settlementid'];
      accountInfo = json['accountinfo'];
    }catch(e) {
      settlementId = "";
      accountInfo = "";
    }
    isMerged = json['ismerged'];
    discountedTotalPrice = json['discountedtotalprice'];
  }

  Map<String, dynamic> toJson() => {
    'settlementpaperid' : settlementPaperId,
    'settlementid' : settlementId,
    'serviceuserid' : serviceUserId,
    'accountinfo' : accountInfo,
    'settlementitems' : settlementItems,
    'totalprice' : totalPrice,
    'sentsettlementitems' : sentSettlementItems,
    'ismerged' : isMerged,
    'discountedtotalprice' : discountedTotalPrice,
  };

  void createSettlementPaper() async {
    await FirebaseFirestore.instance.collection("settlementpaperlist").doc(settlementPaperId).set(toJson());
  }

  Future<List<SettlementPaper>> getSettlementPaperList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("settlementpaperlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<SettlementPaper> papers = [];

    querySnapshot.docs.forEach((doc) async {
      SettlementPaper paper = SettlementPaper.fromQuerySnapshot(doc);
      ServiceUser user = await ServiceUser().getUserByUserId(paper.serviceUserId!);
      userName = user.name;
      papers.add(paper);
    });
    return papers; 
  }

  Future<SettlementPaper> getSettlementPaperByPaperId(String paperid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("settlementpaperlist")
        .doc(paperid).get();
    // ServiceUser user = await ServiceUser().getUserByUserId(serviceUserId!);
    // userName = user.name;
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