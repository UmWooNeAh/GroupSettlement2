import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/common_fireservice.dart';
import '../class/class_group.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';


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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('모델 생성 및 관리'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() { });
        },
        child: Column(
          children: [
            SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: "생성할 객체 이름을 입력해주세요.",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    )
                ),
                TextButton(
                  onPressed: () async{
                    ReceiptItem model = ReceiptItem();
                    model.menuName = "이셰프";
                    model.menuPrice = 34000;
                    model.menuCount = 1;

                    print('객체 생성이 완료되었습니다.');
                    print("${model.receiptItemId}");
                    model.createReceiptItem();
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


