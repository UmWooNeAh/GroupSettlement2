import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modeluuid.dart';

class NickName {

  String? nickName;
  String? serviceuserId;

  NickName() {
    this.nickName;
    this.serviceuserId;
  }

  NickName.fromJson(dynamic json) {
    nickName = json['nickname'];
    serviceuserId = json['serviceuserid'];
  }

  Map<String, dynamic> toJson() => {
    'nickname' : nickName,
    'serviceuserid' : serviceuserId
  };

  void createNickname() async {
    await FirebaseFirestore.instance.collection("nicknamelist").doc(nickName).set(toJson());
  }

  Future<NickName> getNickNameByNickNameId(String nickname) async {
    DocumentSnapshot<Map<String, dynamic>> result =
    await FirebaseFirestore.instance.collection("nicknamelist").doc(nickname).get();
    NickName nname = NickName.fromSnapShot(result);
    return nname;
  }

  //닉네임 중복 검사, 친구 검색 시 존재하는지
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

  NickName.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  NickName.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data());

}