import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_receipt.dart';
import 'package:groupsettlement2/class/class_receiptitem.dart';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:groupsettlement2/viewmodel/GroupViewModel.dart';
import '../class/class_alarm.dart';
import '../class/class_friend.dart';
import '../class/class_group.dart';
import '../class/class_receiptContent.dart';
import '../class/class_settlement.dart';
import '../clova/clova.dart';
import '../main.dart';
import '../viewmodel/SettlementCreateViewModel.dart';
import '../viewmodel/SettlementViewModel.dart';
import 'dart:io';

void removeSettlement(Settlement last) async {
  FireService().deleteDoc("settlementlist", last.settlementId!);
  ServiceUser me = await ServiceUser().getUserByUserId("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb");
  me.settlements.removeLast();
  Group mygroup = await Group().getGroupByGroupId("1800d31d-6d49-4672-8ca7-d094b1a2e1d5");
  mygroup.settlements.removeLast();

  FireService().updateDoc("userlist", me.serviceUserId!, me.toJson());
  FireService().updateDoc("grouplist", mygroup.groupId!, mygroup.toJson());
}
class VMTestPage extends ConsumerStatefulWidget {
  const VMTestPage({super.key});

  @override
  ConsumerState<VMTestPage> createState() => _VMTestPageState();
}

class _VMTestPageState extends ConsumerState<VMTestPage> {

  bool textFlag = false;
  bool flag = false;
  late ReceiptContent rcpcontent;
  late Future<bool> nicknameexisted;

  Friend me = Friend();
  String otherfid = "318ae5b6-cb6c-4fc1-a58d-3c47b441ddf0";
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(groupProvider);
    me.friendId = "d8c90494-f1a5-4d8e-b4da-08c64082d737";

    //nicknameexisted = ServiceUser().isexistingNickname("아나콘다");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('뷰모델 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(onPressed: () {
                removeSettlement(vm.settlementInGroup[0]);
              }, child: Icon(Icons.add)),
              ElevatedButton(onPressed: () {
                //me.acceptFriend(otherfid);
                vm.mergeSettlements([0,1], "병합 정산");
              }, child: Icon(Icons.summarize)),
            ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.settlementInGroup.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "정산 ${index + 1}: ${vm.settlementInGroup[index].settlementName}",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                },
              ),
           ),
          SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
