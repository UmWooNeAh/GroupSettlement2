import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';
import 'package:groupsettlement2/viewmodel/GroupViewModel.dart';
import '../class/class_settlement.dart';
import '../main.dart';

final vmProvider = StateNotifierProvider<vmNotifier, GroupViewModel>((ref) => vmNotifier());
final vmProvdier2 = ChangeNotifierProvider<vmNotifier2> ((ref) => vmNotifier2());
final vmProvider3 = FutureProvider<List<Settlement>>((ref) async {
  final GroupViewModel vm = await GroupViewModel("88f8433b-0af1-44be-95be-608316118fad");
  return vm.settlementInGroup;
});

class vmNotifier extends StateNotifier<GroupViewModel> {
  //uvmNotifier(): super(UserViewModel("8dcca5ca-107c-4a12-9d12-f746e2e513b7")); //신성민
  vmNotifier(): super(GroupViewModel("88f8433b-0af1-44be-95be-608316118fad")); //엄우네아

  void merge() async {
    state.mergeSettlement(state.settlementInGroup[0], state.settlementInGroup[1], "합쳐진 새로운 정산");
  }
  void remerge() async {
    state.restoreMergedSettlement(state.mergedSettlementInGroup[0]);
  }
}

class vmNotifier2 extends ChangeNotifier {
  GroupViewModel vm = GroupViewModel("");

  void fetchgvm() {
    vm = GroupViewModel("88f8433b-0af1-44be-95be-608316118fad");
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
  }
  @override
  Widget build(BuildContext context) {
    //List<Group> mygroup = ref.watch(uvmMyGroupProvider).mygroup;
    final GroupViewModel gvm = ref.watch(vmProvdier2).vm;
    ref.read(vmProvdier2).fetchgvm();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('그룹뷰모델 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconButton(onPressed: () {
              //ref.read(uvmProvdier2.notifier).fetchgvm();
              setState(() {
              });
            }, icon: Icon(Icons.smart_button, size: 60,)),
            gvm.settlementInGroup.isEmpty ?
            Text("그냥 정산: 현재 담긴 목록이 없습니다.", style: TextStyle(fontSize: 30),) :
            Expanded(
              child:
              ListView.builder(
                itemCount: gvm.settlementInGroup.length,
                itemBuilder: (context, index) {
                  if(gvm.settlementInGroup[index].isMerged == false) {
                    return ListTile(
                      title: Text("정산 ${index + 1}: ${gvm
                          .settlementInGroup[index].settlementName}",
                        style: TextStyle(fontSize: 30),),
                      //subtitle: Text("진행중인 정산: ${mygroup[index].settlements.length}개", style: TextStyle(fontSize: 20),),
                    );
                  }
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

