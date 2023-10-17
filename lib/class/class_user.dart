import 'package:cloud_firestore/cloud_firestore.dart';
import 'class_settlement.dart';
import 'package:groupsettlement2/modeluuid.dart';

class ServiceUser {
 
  String? serviceUserId;
  String? name;
  String? kakaoId;
  String? fcmToken;
  int? tokenTimestamp;
  List<String> groups = <String> [];
  List<String> settlements = <String> [];
  List<String> settlementPapers = <String> [];
  List<String> accountInfo = <String> [];
  List<String> savedReceipts = <String> [];

  ServiceUser () {
    ModelUuid uuid = ModelUuid();
    serviceUserId = uuid.randomId;
    kakaoId = "";
    fcmToken = "";
    tokenTimestamp = 0;
  }

  ServiceUser.fromJson(dynamic json) {
    serviceUserId = json['serviceuserid'];
    name = json['name'];
    kakaoId = json['kakaoid'];
    fcmToken = json['fcmtoken'];
    groups = List<String>.from(json["groups"]);
    settlements = List<String>.from(json["settlements"]);
    settlementPapers = List<String>.from(json["settlementpapers"]);
    accountInfo = List<String>.from(json["accountinfo"]);
    savedReceipts = List<String>.from(json["savedreceipts"]);
  }

  Map<String, dynamic> toJson() => {
    'serviceuserid' : serviceUserId,
    'name' : name,
    'kakaoid' : kakaoId,
    'fcmtoken' : fcmToken,
    'groups' : groups,
    'settlements' : settlements,
    'settlementpapers' : settlementPapers,
    'accountinfo' : accountInfo,
    'savedreceipts' : savedReceipts,
  };

  void createUser() async {
    await FirebaseFirestore.instance.collection("userlist").doc(serviceUserId).set(toJson());
  }

  Future<List<ServiceUser>> getUserList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("userlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<ServiceUser> users = [];
    for(var doc in querySnapshot.docs) {
      ServiceUser user = ServiceUser.fromQuerySnapshot(doc);
      users.add(user);
    }
    return users;
  }

  Future<ServiceUser> getUserByUserId(String userid) async{
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("userlist").doc(userid).get();
    ServiceUser user = ServiceUser.fromSnapShot(result);
    return user;
  }

  Future<List<Settlement>> getSettlementListInUser() async {
    List<Settlement> stmlist = [];
    for(var stmid in settlements!) {
      DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("settlementlist").doc(stmid).get();
      Settlement stm = Settlement.fromSnapShot(result);
      stmlist.add(stm);
    }
    return stmlist;
  }

  ServiceUser.fromSnapShot(
    DocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromJson(snapshot.data());

  ServiceUser.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    :this.fromJson(snapshot.data());

}

