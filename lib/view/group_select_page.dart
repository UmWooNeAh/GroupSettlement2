import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../class/class_group.dart';
import '../design_element.dart';
import '../viewmodel/UserViewModel.dart';

class groupSelectPage extends ConsumerStatefulWidget {
  final String userId;
  const groupSelectPage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<groupSelectPage> createState() => _groupSelectPage();
}

class _groupSelectPage extends ConsumerState<groupSelectPage> {
  late UserViewModel uvm;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    uvm = ref.watch(userProvider);

    Size size = MediaQuery.of(context).size;

    Future<bool> refreshing() async {
      if(isFirst) {
        isFirst = false;
        await uvm.settingUserViewModel(widget.userId);
      }
      return true;
    }
    
    return Scaffold(
        appBar:AppBar(),
        body:FutureBuilder(
          future: refreshing(),
          builder: (context, snapshot) {
            if(snapshot.hasData == false){
              return Center(child:CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "내 그룹",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go("/groupCreatePage");
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                            "+",
                                            style: TextStyle(
                                                fontSize: 35,
                                                color: Color(0xFF838383))
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                            width: 50, height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 2,
                                                  color: Color(0xFF838383)),
                                              shape: BoxShape.circle,
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "새 그룹 만들기",
                                      style: TextStyle(
                                          color: Color(0xFF838383),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                            children: List.generate(uvm.myGroup.length, (
                                index) {
                              return groupOne(group: uvm.myGroup[index]);
                            })
                        )
                      ]
                  ),
                ),
              );
            }
          }
        ),
    );
  }
}

class groupOne extends ConsumerStatefulWidget {
  final Group group;
  const groupOne({Key? key, required this.group}) : super(key: key);

  @override
  ConsumerState<groupOne> createState() => _groupOneState();
}

class _groupOneState extends ConsumerState<groupOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap:(){
            print(widget.group.groupName);
            context.go("/groupMainPage",extra: widget.group.groupId);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Row(
                    children:[
                      Container(
                        width: 75, height: 75,
                        decoration: BoxDecoration(
                          color: groupColor[Random().nextInt(groupColor.length)],
                          shape: BoxShape.circle,
                        ),
                        child:Padding(
                          padding: const EdgeInsets.only(top:17),
                          child: Text(
                              widget.group.groupName![0],
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                color:Colors.white,
                                fontSize: 25,
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                  widget.group.groupName!,
                                  style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17
                                  )
                              ),
                              SizedBox(height:5),
                              Text(
                                  "진행 중인 정산 : ${widget.group.settlements.length} 개",
                                  style: TextStyle(
                                    color: Color(0xFFFE5F55),
                                    fontWeight: FontWeight.w500,
                                  )
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
                GestureDetector(
                  onTap:(){},
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:25),
                    child: Text(
                        "시간",
                        style:TextStyle(
                          color:Color(0xFF838383),
                        )
                    ),
                  ),
                )
              ]
          ),
        ),
        Divider()
      ],
    );
  }
}
