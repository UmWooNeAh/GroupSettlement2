import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:groupsettlement2/viewmodel/GroupViewModel.dart';
import '../class/class_settlement.dart';
import '../main.dart';
import '../viewmodel/SettlementViewModel.dart';

final provider = Provider<SettlementViewModel> ((_) => SettlementViewModel("54d974c2-ea2a-4998-89a3-6d9cca52db80"));
final vmProvider = StateNotifierProvider<vmNotifier, SettlementViewModel>((ref) => vmNotifier());
final vmProvdier2 = ChangeNotifierProvider<vmNotifier2>((ref) => vmNotifier2());
final vmProvider3 = FutureProvider<SettlementViewModel>((ref) async {
  final vm = await ref.watch(provider);
  return vm;
});

class vmNotifier extends StateNotifier<SettlementViewModel> {
  vmNotifier() : super(SettlementViewModel("")) {
    load("54d974c2-ea2a-4998-89a3-6d9cca52db80");
  } //엄우네아

  Future<void> load(String id) async {
    state = SettlementViewModel(id);
  }
}

class vmNotifier2 extends ChangeNotifier {
  SettlementViewModel vm = SettlementViewModel("");

  void fetchgvm() {
    vm = SettlementViewModel("54d974c2-ea2a-4998-89a3-6d9cca52db80");
    notifyListeners();
  }
}

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
  void initState() {
    super.initState();
    ref.read(vmProvider);
  }

  @override
  Widget build(BuildContext context) {
    final svm = ref.watch(vmProvider);
    log("값: ${svm.settlement.settlementName}");
    //final SettlementViewModel svm = ref.watch(vmProvdier2).vm;
    //ref.read(vmProvdier2).fetchgvm();
    //final svm = ref.watch(vmProvider3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('정산뷰모델 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                  });
                },
                icon: Icon(
                  Icons.smart_button,
                  size: 60,
                )),
           Expanded(
              child: ListView.builder(
                itemCount: svm.receiptItems.length,
                itemBuilder: (context, index) {
                  String key = svm.receiptItems.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      "영수증 항목 ${index + 1}: ${svm.receiptItems[key]!.menuName}",
                      style: TextStyle(fontSize: 30),
                    ),
                    subtitle: Text(
                      "개수: ${svm.receiptItems[key]!.menuCount}개, 금액: ${svm.receiptItems[key]!.menuPrice}원",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
           ),
            /*uvm.mergedSettlementInGroup.isEmpty ?
              Text("합쳐진 정산: 현재 담긴 목록이 없습니다.", style: TextStyle(fontSize: 30),) :
              Expanded(
                child:
                ListView.builder(
                  itemCount: uvm.mergedSettlementInGroup.length,
                  itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("합쳐진 정산 ${index + 1}: ${uvm
                            .mergedSettlementInGroup[index].settlementName}",
                          style: TextStyle(fontSize: 30),),
                        //subtitle: Text("진행중인 정산: ${mygroup[index].settlements.length}개", style: TextStyle(fontSize: 20),),
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
