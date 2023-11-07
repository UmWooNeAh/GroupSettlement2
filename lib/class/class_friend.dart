import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../common_fireservice.dart';
import '../modeluuid.dart';
import 'class_user.dart';

class Friend {

  String? friendId;
  String? name;
  String? nickname;

  Friend() {
    ModelUuid uuid = ModelUuid();
    friendId = uuid.randomId;
  }

  Friend.fromJson(dynamic json) {
    friendId = json['friendid'];
    name = json['firstusername'];
    nickname = json['firstusernickname'];
  }

  Map<String, dynamic> toJson() => {
    'friendid': friendId,
    'name': name,
    'nickname': nickname,
  };

  void createFriend() async {
    await FirebaseFirestore.instance.collection("friendlist").doc(friendId).set(toJson());
  }

  Future<List<Friend>> getFriendList() async {
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection("friendlist");
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _collectionReference.get();
    List<Friend> friends = [];
    for(var doc in querySnapshot.docs) {
      Friend friend = Friend.fromQuerySnapshot(doc);
      friends.add(friend);
    }
    return friends;
  }

  Future<Friend> getFriendByFriendId(String friendid) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("friendlist").doc(friendid).get();
    Friend friend = Friend.fromSnapShot(result);
    return friend;
  }

  Friend.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Friend.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}