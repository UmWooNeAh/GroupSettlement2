import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, List<ServiceUser>>((ref) => UserStateNotifier());
final userProvider2 = ChangeNotifierProvider<UserChangeNotifier>((ref) => UserChangeNotifier());

class UserStateNotifier extends StateNotifier<List<ServiceUser>> {
  UserStateNotifier() : super([]); //초기화 부분

  void addUser(ServiceUser user) {
    state = [...state, user];
    //state.add(user);
  }
  void deleteUser(ServiceUser removeUser) {
    state = state.where((user) => user != removeUser).toList();
  }
}

class UserChangeNotifier extends ChangeNotifier {
   //초기화 부분
  final List<ServiceUser> userlist = [];

  void addUser(ServiceUser user) {
    userlist.add(user);
    notifyListeners();
  }
  void deleteUser(ServiceUser removeUser) {
    userlist.remove(removeUser);
    notifyListeners();
  }
}

class SinPage extends ConsumerStatefulWidget {
  const SinPage({super.key});

  @override
  ConsumerState<SinPage> createState() => _SinPageState();
}

class _SinPageState extends ConsumerState<SinPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final userlist = ref.watch(userProvider);
    List<ServiceUser> userlist = ref.watch(userProvider2).userlist;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('유저 생성 및 관리'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() { });
        },
        child: Column(
          children: [
            userlist.isEmpty
              ? Text("담긴 유저가 없습니다.")
              : Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        //ref.watch(userProvider.notifier).deleteUser(userlist[index]);
                        ref.watch(userProvider2.notifier).deleteUser(userlist[index]);
                      },
                    child: ListTile(
                      title: Text("${userlist[index].name}"),
                      subtitle: Text("${userlist[index].serviceUserId}"),
                    ),
                  );
                  },
                itemCount: userlist.length,
              ),
            ),
            SizedBox(width:0, height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: "생성할 유저 이름을 입력해주세요.",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    )
                ),
                TextButton(
                  onPressed: () async{
                    Receipt receipt = Receipt();
                    receipt.receiptName = _inputController.text;
                    receipt.storeName = '';
                    receipt.time = Timestamp.now();
                    receipt.totalPrice = 0;
                    print('유저 생성이 완료되었습니다.');
                    receipt.createReceipt();
                    _inputController.clear();
                    //ref.watch(userProvider.notifier).addUser(user);

                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
            SizedBox(width:0, height:20),

          ],
        ),
      ),
    );
  }
}


