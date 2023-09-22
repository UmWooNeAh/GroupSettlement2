import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupsettlement2/modeluuid.dart';
import 'class_settlement.dart';
import 'class_user.dart';

class Group {

  String? groupId;
  String? groupName;
  List<String> serviceUsers = <String> [];
  List<String> settlements = <String> [];

  Group() {
    ModelUuid uuid = ModelUuid();
    groupId = uuid.randomId;
  }

  Group.fromJson(dynamic json) {
    groupId = json['groupid'];
    groupName = json['groupname'];
    serviceUsers = List<String>.from(json['serviceusers']);
    settlements = List<String>.from(json['settlements']);
  }

  Map<String, dynamic> toJson() => {
    'groupid' : groupId,
    'groupname' : groupName,
    'serviceusers' : serviceUsers,
    'settlements': settlements,
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
  
  Group.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Group.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}