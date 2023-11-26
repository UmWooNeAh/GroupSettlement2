import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/class/class_user.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import '../class/class_group.dart';
import '../design_element.dart';
import '../viewmodel/UserViewModel.dart';

class GroupSelectPage extends ConsumerStatefulWidget {
  const GroupSelectPage({Key? key, required this.me}) : super(key: key);
  final ServiceUser me;

  @override
  ConsumerState<GroupSelectPage> createState() => _GroupSelectPage();
}

class _GroupSelectPage extends ConsumerState<GroupSelectPage> {
  late UserViewModel uvm;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final uvm = ref.watch(userProvider);
    if (isFirst) {
      Future(() {
        uvm.fetchGroup(widget.me);
      });
      isFirst = false;
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: const Text(
                  "내 그룹",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push("/GroupCreate", extra: widget.me);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF838383),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF838383),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "새 그룹 만들기",
                      style: TextStyle(
                          color: Color(0xFF838383),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                children: List.generate(
                  uvm.myGroup.length,
                  (index) {
                    return OneGroup(group: uvm.myGroup[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 1, isIn: false,),
    );
  }
}

class OneGroup extends ConsumerStatefulWidget {
  final Group group;
  const OneGroup({Key? key, required this.group}) : super(key: key);

  @override
  ConsumerState<OneGroup> createState() => _OneGroupState();
}

class _OneGroupState extends ConsumerState<OneGroup> {
  @override
  Widget build(BuildContext context) {
    var uvm = ref.watch(userProvider);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.push("/GroupSelect/GroupMain",
                extra: [uvm.userData, widget.group.groupId!]);
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: groupColor[Random().nextInt(groupColor.length)],
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17),
                    child: Text(
                      widget.group.groupName![0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.group.groupName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17)),
                      const SizedBox(height: 5),
                      Text(
                        "진행 중인 정산 : ${widget.group.settlements.length} 개",
                        style: const TextStyle(
                          color: Color(0xFFFE5F55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Text("시간",
                    style: TextStyle(
                      color: Color(0xFF838383),
                    )),
              ),
            )
          ]),
        ),
        const Divider(),
      ],
    );
  }
}
