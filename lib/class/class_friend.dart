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

  void _requestFriend(String otherfriendid) async {
    ServiceUser other = await ServiceUser().getUserByUserId(_hashing(otherfriendid));
    other.requestedFriend.add(friendId!);
    FireService().updateDoc("userlist", other.serviceUserId!, other.toJson());
  }

  void acceptFriend(String otherfriendid) async {
    ServiceUser me = await ServiceUser().getUserByUserId(_hashing(friendId!));
    ServiceUser other = await ServiceUser().getUserByUserId(_hashing(otherfriendid));

    me.requestedFriend.remove(otherfriendid);
    me.friends.add(otherfriendid);
    other.friends.add(friendId!);

    FireService().updateDoc("userlist", me.serviceUserId!, me.toJson());
    FireService().updateDoc("userlist", other.serviceUserId!, other.toJson());
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

  Friend.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Friend.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}