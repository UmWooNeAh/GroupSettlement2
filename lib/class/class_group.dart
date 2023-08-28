import 'package:cloud_firestore/cloud_firestore.dart';
import 'class_settlement.dart';
import 'class_user.dart';

class Group {

  String? groupId;
  List<String>? settlements;
  List<String>? serviceUsers;
  String? groupName;

  Group({
    this.groupId,
    this.settlements,
    this.serviceUsers,
    this.groupName
  });

  Group.fromJson(dynamic json) {
    groupId = json['groupid'];
    settlements = List<String>.from(json["settlements"]);
    serviceUsers = List<String>.from(json["serviceusers"]);
    groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() => {
    'groupid' : groupId,
    'settlements': settlements,
    'serviceusers' : serviceUsers,
    'groupName' : groupName,
  };

  void createGroup() async {
    await FirebaseFirestore.instance.collection("grouplist").doc(this.groupId).set(toJson());
  }

  Future<List<Group>> getGroupList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("grouplist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<Group> groups = [];
    for(var doc in querySnapshot.docs) {
      Group group = Group.fromQuerySnapshot(doc);
      groups.add(group);
    }
    return groups;
  }

  Future<Group> getGroupByGroupId(String groupid) async{
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("grouplist").doc(groupid).get();
    Group group = Group.fromSnapShot(result);
    return group;
  }

  Future<List<ServiceUser>> getUserListInGroup() async {
    List<ServiceUser> userlist = [];
    for(var userid in serviceUsers!) {
      DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("userlist").doc(userid).get();
      ServiceUser user = ServiceUser.fromSnapShot(result);
      userlist.add(user);
    }
    return userlist;
  }

  Future<List<Settlement>> getSettlementListInGroup() async {
    List<Settlement> stmlist = [];
    for(var stmid in settlements!) {
      DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("settlementlist").doc(stmid).get();
      Settlement stm = Settlement.fromSnapShot(result);
      stmlist.add(stm);
    }
    return stmlist;
  }

  Group.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Group.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}