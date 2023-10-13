import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/class_user.dart';
import '../design_element.dart';
import '../viewmodel/GroupViewModel.dart';

class groupCreatePage extends ConsumerStatefulWidget {
  const groupCreatePage({Key? key}) : super(key: key);

  @override
  ConsumerState<groupCreatePage> createState() => _groupCreatePageState();
}

class _groupCreatePageState extends ConsumerState<groupCreatePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String inputName = "";
    String inputGroupName = "";
    final gvm = ref.watch(groupProvider);
    return Scaffold(
      appBar: AppBar(),
      body:
        GestureDetector(
          onTap:()=>FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text("새 그룹 생성하기",
                    style:TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.w800,
                    )
                  ),
                ),
                SizedBox(width:double.infinity,height: 30),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text("그룹 이름을 입력해주세요.",
                    style:TextStyle(
                      fontSize:18,
                      fontWeight: FontWeight.w600
                    )
                  ),
                ),
                Align(
                  alignment:Alignment.center,
                  child: SizedBox(
                    width: size.width*0.9,
                    child: TextField(
                      onChanged: (value) {
                        inputGroupName = value;
                      },
                      decoration: InputDecoration(
                        hintText: "그룹 1",
                        labelStyle: TextStyle(
                            color:Color(0xFF838383)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width:double.infinity, height: 50),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:Color(0xFFF4F4F4),
                    boxShadow: [
                      BoxShadow(
                        color:Color(0xFFDEDEDE),
                        blurRadius: 1,
                        offset:Offset(1,3)
                      ),
                      BoxShadow(
                          color:Color(0xFFDEDEDE),
                          blurRadius: 1,
                          offset:Offset(1,-3)
                      )
                    ]
                  ),
                  child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("그룹원",
                              style:TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(
                                        text:"${gvm.myGroup.serviceUsers.length.toString()} ",
                                        style: TextStyle(
                                          color: Color(0xFF07BEB8),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                    TextSpan(
                                        text:"명",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                  ]
                              )
                          )
                        ]
                      ),
                    )
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      color:Color(0xFFF4F4F4)
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height:20),
                            Column(
                              children: List.generate((gvm.serviceUsers.length/4).toInt()+1,(index){
                                return Row(
                                  children: List.generate(4, (innerIndex){
                                    try {
                                      return oneUser(flag: false,user: gvm.serviceUsers[index*4+innerIndex]);
                                    } on RangeError catch (e) {
                                      return SizedBox.shrink();
                                    }
                                  }),
                                );
                              }),
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:10),
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: Container(
                            width: size.width * 0.42, height: 55,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color:Color(0xFF07BEB8)),
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:Center(
                                child: Text("Yemon 친구 추가",
                                    style:TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )
                                )
                            )
                        ),
                      ),
                      SizedBox(width:size.width*0.05),
                      Padding(
                        padding: const EdgeInsets.only(right:20),
                        child: Container(
                            width: size.width * 0.42, height: 55,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color:Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("추가할 사용자의 이름을 입력해주세요",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                    )
                                  ),
                                  content: TextField(
                                    decoration: InputDecoration(
                                      hintText: "사용자 1",
                                      labelStyle: TextStyle(
                                          color:Color(0xFF838383)
                                      ),
                                    ),
                                    onChanged: (value) {
                                      inputName = value;
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        ServiceUser user = ServiceUser();
                                        user.name = value;
                                        user.groups.add(gvm.myGroup.groupId!);
                                        gvm.addByDirect(user);
                                      });
                                    },
                                  ),
                                  actionsAlignment: MainAxisAlignment.spaceBetween,
                                  actions: [
                                    SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            ServiceUser user = ServiceUser();
                                            user.name = inputName;
                                            user.groups.add(gvm.myGroup.groupId!);
                                            gvm.addByDirect(user);
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: color2,
                                          side: const BorderSide(
                                            color: color2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),

                                        ),
                                        child: const Text(
                                          "인원 추가",
                                          style:
                                          TextStyle(fontSize: 15, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "취소",
                                          style:
                                          TextStyle(fontSize: 15, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: Center(
                                  child: Text("직접 인원 추가",
                                      style:TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600
                                      )
                                  )
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 10,color:Color(0xFFF4F4F4)),
                Container(
                  width:double.infinity,
                  height:80,
                  child:GestureDetector(
                    child:
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: size.width * 0.9, height: 55,
                            decoration: ShapeDecoration(
                                color: Color(0xFF07BEB8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            child:GestureDetector(
                              onTap: (){
                                print(inputGroupName);
                              },
                              child: Center(
                                  child: Text("그룹 생성하기",
                                      style:TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:Colors.white
                                      )
                                  )
                              ),
                            )
                        ),
                      ),
                  )
                ),
              ],
            ),
          ),
        )
    );
  }
}


class oneUser extends StatefulWidget {
  final bool flag;
  final ServiceUser user;

  const oneUser({Key? key, required this.flag, required this.user}) : super(key: key);

  @override
  State<oneUser> createState() => _oneUserState();
}

class _oneUserState extends State<oneUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:35),
      child: Container(
        width: 60,
        height: 122,
        child:
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                color: Color(0xFF838383),
                shape: OvalBorder(),
              ),
            ),
            SizedBox(height:5),
            Text(widget.user.name!,
                style:TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
                )
            ),
            Text(widget.flag ? "직접 추가함" : "",
                style:TextStyle(
                  fontSize: 10,
                  color: Color(0xFF838383),
                )
            )
          ],



        ),
      ),
    );
  }
}