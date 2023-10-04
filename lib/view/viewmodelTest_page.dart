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
import '../class/class_settlement.dart';
import '../main.dart';
import '../viewmodel/SettlementViewModel.dart';

final userProvider = ChangeNotifierProvider<UserViewModel>(
    (ref) => UserViewModel("8dcca5ca-107c-4a12-9d12-f746e2e513b7"));
final groupProvider = ChangeNotifierProvider<GroupViewModel>(
    (ref) => GroupViewModel("88f8433b-0af1-44be-95be-608316118fad"));
final stmProvider = ChangeNotifierProvider<SettlementViewModel>(
    (ref) => SettlementViewModel("54d974c2-ea2a-4998-89a3-6d9cca52db80"));

/*class uvmChangeNotifier extends ChangeNotifier {
  UserViewModel uvm = UserViewModel("8dcca5ca-107c-4a12-9d12-f746e2e513b7");
}*/

class VMTestPage extends ConsumerStatefulWidget {
  const VMTestPage({super.key});

  @override
  ConsumerState<VMTestPage> createState() => _VMTestPageState();
}

class _VMTestPageState extends ConsumerState<VMTestPage> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(stmProvider).receipts;

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
            Expanded(
              child: ListView.builder(
                itemCount: vm.length,
                itemBuilder: (context, index) {
                  String key = vm.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      "항목 ${index + 1}: ${vm[key]!.receiptName}",
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                },
              ),
            ),
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
