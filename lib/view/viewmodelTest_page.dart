import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_receipt.dart';
import 'package:groupsettlement2/class/class_receiptitem.dart';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:groupsettlement2/viewmodel/GroupViewModel.dart';
import '../class/class_alarm.dart';
import '../class/class_group.dart';
import '../class/class_receiptContent.dart';
import '../class/class_settlement.dart';
import '../clova/clova.dart';
import '../main.dart';
import '../viewmodel/SettlementCreateViewModel.dart';
import '../viewmodel/SettlementViewModel.dart';
import 'dart:io';


class VMTestPage extends ConsumerStatefulWidget {
  const VMTestPage({super.key});

  @override
  ConsumerState<VMTestPage> createState() => _VMTestPageState();
}

class _VMTestPageState extends ConsumerState<VMTestPage> {

  bool textFlag = false;
  bool flag = false;
  late ReceiptContent rcpcontent;

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(stmCreateProvider);
    //final SettlementViewModel svm = ref.watch(vmProvdier2).vm;
    //ref.read(vmProvdier2).fetchgvm();
    //final svm = ref.watch(vmProvider3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('뷰모델 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: () async {
              await vm.clova.pickPicture();
              setState((){
                if(vm.clova.imageFile != null) {
                  flag = true;
                }
              });
            }, child: Text("Pick")),

            ElevatedButton(onPressed: () async {
              var json = await vm.clova.analyze();
              log(json.toString());
              rcpcontent = vm.createReceiptFromNaverOCR("Demo 영수증", json);
              setState(() {
                textFlag = true;
              });
            }, child: Text("Analyze")),
            textFlag ? Text("영수증 이름: ${rcpcontent.receipt!.receiptName}",
                style: const TextStyle(fontSize: 25)): Text(""),
            textFlag ? Text("거래일시: ${rcpcontent.receipt!.time}",
                style: const TextStyle(fontSize: 25)): Text(""),
            textFlag ? Text("업체명: ${rcpcontent.receipt!.storeName}",
                style: const TextStyle(fontSize: 25)): Text(""),
            Expanded(
              child: textFlag ? ListView.builder(
                shrinkWrap: true,
                itemCount: rcpcontent.receiptItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "메뉴 ${index + 1}: ${rcpcontent.receiptItems[index].menuName}",
                      style: const TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(
                      " 수량: ${rcpcontent.receiptItems[index].menuCount}, 가격: ${rcpcontent.receiptItems[index].menuPrice}",
                      style: const TextStyle(fontSize: 25),
                    ),
                  );
                },
              ) : Text("")
            ),
            textFlag ? Text("합계 금액: ${rcpcontent.receipt!.totalPrice}원",
                style: const TextStyle(fontSize: 25)): Text(""),
            /*Expanded(
              child: ListView.builder(
                itemCount: svm.receipts.length,
                itemBuilder: (context, index) {
                  String key = svm.receipts.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      "영수증 항목 ${index + 1}: ${svm.receipts[key]!.receiptName}",
                      style: TextStyle(fontSize: 30),
                    ),
                    subtitle: Text(
                      "날짜: ${svm.receipts[key]!.time!.toDate()}",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
           ),
              */
          ],
        ),
      ),
    );
  }
}
