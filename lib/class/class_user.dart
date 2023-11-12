import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../common_fireservice.dart';
import 'class_settlement.dart';
import 'package:groupsettlement2/modeluuid.dart';

class ServiceUser {
 
  String? serviceUserId;
  String? friendId;
  String? name;
  String? nickname;
  String? kakaoId;
  String? fcmToken;
  Timestamp? tokenTimestamp;
  List<String> groups = <String> [];
  List<String> settlements = <String> [];
  List<String> settlementPapers = <String> [];
  List<String> accountInfo = <String> [];
  List<String> savedReceipts = <String> [];
  List<String> friends = [];
  List<String> requestedFriend = [];

  ServiceUser () {
    ModelUuid uuid = ModelUuid();
    friendId = uuid.randomId;
    serviceUserId = _hashing(friendId!);
    kakaoId = "";
    fcmToken = "";
  }

  ServiceUser.fromJson(dynamic json) {
    serviceUserId = json['serviceuserid'];
    friendId = json['friendid'];
    name = json['name'];
    nickname = json['nickname'];
    kakaoId = json['kakaoid'];
    fcmToken = json['fcmtoken'];
    tokenTimestamp = json['tokentimestamp'];
    groups = List<String>.from(json["groups"]);
    settlements = List<String>.from(json["settlements"]);
    settlementPapers = List<String>.from(json["settlementpapers"]);
    accountInfo = List<String>.from(json["accountinfo"]);
    savedReceipts = List<String>.from(json["savedreceipts"]);
    friends = List<String>.from(json["friends"]);
    requestedFriend = List<String>.from(json["requestedfriend"]);
  }

  Map<String, dynamic> toJson() => {
    'serviceuserid' : serviceUserId,
    'friendid' : friendId,
    'name' : name,
    'nickname' : nickname,
    'kakaoid' : kakaoId,
    'fcmtoken' : fcmToken,
    'tokentimestamp' : tokenTimestamp,
    'groups' : groups,
    'settlements' : settlements,
    'settlementpapers' : settlementPapers,
    'accountinfo' : accountInfo,
    'savedreceipts' : savedReceipts,
    'friends' : friends,
    'requestedfriend' : requestedFriend,
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
    for(var stmid in settlements) {
      DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("settlementlist").doc(stmid).get();
      Settlement stm = Settlement.fromSnapShot(result);
      stmlist.add(stm);
    }
    return stmlist;
  }

  Future<bool> isexistingNickname(String nickname) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("nicknamelist").doc(nickname).get();
    if(result.exists) {
      log("해당 닉네임은 중복되는 닉네임입니다. 다시 입력해주세요.");
      return true;
    }
    log("닉네임이 중복되지 않습니다.");
    return false;
  }

  String _hashing(String fid) {
    String sid = "";
    List<int> hiphen = [8, 13, 18, 23];
    for (int i = 0; i < 36; i++) {
      if (hiphen.contains(i)) {
        sid += '-';
        continue;
      }
      int ordfi = fid.codeUnitAt(i);
      if ('0'.codeUnitAt(0) <= ordfi && ordfi <= '9'.codeUnitAt(0)) {
        ordfi = ordfi - '0'.codeUnitAt(0) + 1;
      } else if ('a'.codeUnitAt(0) <= ordfi && ordfi <= 'z'.codeUnitAt(0)) {
        ordfi = ordfi - 'a'.codeUnitAt(0) + 11;
      }

      int key = 7;
      int fi = key;
      for (int j = 0; j < ordfi; j++) {
        fi *= key;
        fi %= 37;
      }

      if (fi <= 10) {
        sid += String.fromCharCode('0'.codeUnitAt(0) + fi - 1);
      } else if (fi > 10) {
        sid += String.fromCharCode('a'.codeUnitAt(0) + fi - 11);
      }
    }

    return sid;
  }

  ServiceUser.fromSnapShot(
    DocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromJson(snapshot.data());

  ServiceUser.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    :this.fromJson(snapshot.data());

}

