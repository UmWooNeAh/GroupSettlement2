import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../common_fireservice.dart';
import '../modeluuid.dart';
import 'class_nickname.dart';
import 'class_user.dart';

class Friend {

  String? friendId;
  String? firstUserName;
  String? firstUserNickname;
  String? secondUserName;
  String? secondUserNickname;
  bool? accepted;

  Friend() {
    ModelUuid uuid = ModelUuid();
    friendId = uuid.randomId;
    accepted = false;
  }

  Friend.fromJson(dynamic json) {
    friendId = json['friendid'];
    firstUserName = json['firstusername'];
    firstUserNickname = json['firstusernickname'];
    secondUserName = json['secondusername'];
    secondUserNickname = json['secondusernickname'];
    accepted = json['accepted'];
  }

  Map<String, dynamic> toJson() => {
    'friendid': friendId,
    'firstusername': firstUserName,
    'firstusernickname': firstUserNickname,
    'secondusername' : secondUserName,
    'secondusernickname' : secondUserNickname,
    'accepted' : accepted
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

  void initFriend(String username, String firstnickname, String secondnickname) async {
    if(await NickName().isexistingNickname(secondnickname)) {
      Friend newfriend = Friend();
      newfriend.firstUserName = username;
      newfriend.firstUserNickname = firstnickname;
      newfriend.createFriend();
      _requestFriend(secondnickname, newfriend);
    }
    else {
      print("존재하지 않는 닉네임입니다.");
    }

  }

  void _requestFriend(String nickname, Friend friend) async {
    NickName nname = await NickName().getNickNameByNickNameId(nickname);
    ServiceUser other = await ServiceUser().getUserByUserId(nname.serviceuserId!);
    friend.secondUserName = other.name;
    friend.secondUserNickname = nname.nickName;
    other.requestedFriend.add(friend.friendId!);

    FireService().updateDoc("userlist", other.serviceUserId!, other.toJson());
    FireService().updateDoc("friendlist", friend.friendId!, friend.toJson());
  }

  void clickaccept(Friend friend) async {
    friend.accepted = true;
    FireService().updateDoc("friendlist", friend.friendId!, friend.toJson());
    _acceptFriend(friend);
  }
  //상대방이 friend의 accepted를 true로 전환하면, 즉 친구 요청을 수락하면 작동하는 메소드
  void _acceptFriend(Friend friend) async {
    if(friend.accepted == false ) {
      print("에러 발생, 다시 시도해주세요.");
      return;
    }
    NickName firstnname = await NickName().getNickNameByNickNameId(friend.firstUserNickname!);
    NickName secondnname = await NickName().getNickNameByNickNameId(friend.secondUserNickname!);
    ServiceUser firstuser = await ServiceUser().getUserByUserId(firstnname.serviceuserId!);
    ServiceUser seconduser = await ServiceUser().getUserByUserId(secondnname.serviceuserId!);

    firstuser.friends[friend.friendId!] = true;
    seconduser.friends[friend.friendId!] = false;
    seconduser.requestedFriend.remove(friend.friendId);

    FireService().updateDoc("userlist", firstuser.serviceUserId!, firstuser.toJson());
    FireService().updateDoc("userlist", seconduser.serviceUserId!, seconduser.toJson());

  }

  Friend.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Friend.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}