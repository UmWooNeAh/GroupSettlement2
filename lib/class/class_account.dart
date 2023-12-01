import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupsettlement2/modeluuid.dart';

class Account {

  String? accountId;
  String? bank;
  int? accountNum;
  String? accountHolder;
  String? accountAlias;

  Account () {
    ModelUuid uuid = ModelUuid();
    accountId = uuid.randomId;
  }

  Account.fromJson(dynamic json) {
    accountId = json['accountid'];
    bank = json['bank'];
    accountNum = json['accountnum'];
    accountHolder = json['accountholder'];
    accountAlias = json['accountalias'];
  }

  Map<String, dynamic> toJson() => {
    'accountid' : accountId,
    'bank' : bank,
    'accountnum' : accountNum,
    'accountholder' : accountHolder,
    'accountalias' : accountAlias,
  };

  void creatAccount(String userid) async {
    await FirebaseFirestore.instance.collection("accountlist").doc(accountId).set(toJson());
  }

  Future<List<Account>> getMyAccountList(List<String> accounts) async {
    List<Account> acclist = [];
    for(var accid in accounts) {
      DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("accountlist").doc(accid).get();
      Account acc = Account.fromSnapShot(result);
      acclist.add(acc);
    }
    return acclist;
  }

  Account.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

}