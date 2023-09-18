import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../class/class_receipt.dart';
import '../class/class_receiptitem.dart';
import 'clova.dart';
import 'package:riverpod/riverpod.dart';
import 'package:image_picker/image_picker.dart';

class clovaPage extends StatefulWidget {
  const clovaPage({Key? key}) : super(key: key);

  @override
  State<clovaPage> createState() => _clovaPageState();
}

class _clovaPageState extends State<clovaPage> {
  Clova clova = Clova();
  bool flag = false;
  bool textFlag = false;
  Receipt receipt = Receipt();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children:[
                        flag ? Image.file(clova.imageFile!,width:150,height: 150) : Text('null img File'),

                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      ElevatedButton(onPressed: () async {
                        await clova.pickPicture();
                        setState((){
                          if(clova.imageFile != null) {
                            flag = true;
                          }
                        });
                        }, child: Text("Pick")),
                      SizedBox(width:100),
                      ElevatedButton(onPressed: () async {
                        await clova.takePicture();
                        setState((){
                          if(clova.imageFile != null) {
                            flag = true;
                          }
                        });
                        }, child: Text("Take"))
                    ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        ElevatedButton(onPressed: ()async{
                          await clova.analyze();
                          receipt = clova.makeReceipt();
                          setState(() {
                            textFlag = true;
                          });
                        }, child: Text("Analyze")),

                      ]
                    ),
                    textFlag ? Text(receipt!.storeName!+"\n"+receipt!.totalPrice!.toString()) : Text("Analyze First"),

                    Expanded(
                        child:
                          textFlag ? ListView.builder(
                            itemCount: clova.a.length,
                            itemBuilder: (BuildContext,int index){
                              return ListTile(
                                  leading: Text(clova.a[index].receiptItemId!),
                                  title:clova.a[index].menuName != null? Text(clova.a[index].menuName!) : Text("name NotFound"),
                                  subtitle:clova.a[index].menuPrice != null
                                      ? clova.a[index].menuCount != null
                                      ? Text(clova.a[index].menuPrice!.toString() +"  "+ clova.a[index].menuCount!.toString())
                                      : Text(clova.a[index].menuPrice!.toString())
                                      : Text("price NotFound")

                              );
                            },
                          ) : Text(""))
                  ]
                )
            )
        )
    );
  }
}
