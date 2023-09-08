import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../design_element.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height * 0.065,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: colorGrey,
                ),
              ),
              const Text("그룹 모시깽"),
            ],
          ),
          const Divider(
            color: colorGrey,
            thickness: 7,
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 200,
                color: color1,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: size.width * 0.9,
                    color: color1,
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: Text("류지원의 페이지"),
                  ),
                  Positioned(
                    top: 120,
                    left: 10,
                    child: ElevatedButton(
                      child: const Text("Ryu Page"),
                      onPressed: () {
                        context.push("/RyuPage");
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Draggable(
                      data: 10,
                      feedback: Container(
                        height: 20,
                        width: 20,
                        color: color2,
                      ),
                      childWhenDragging: Container(
                        color: Colors.transparent,
                      ),
                      onDraggableCanceled: (velocity, offset) {},
                      child: Container(
                        height: 20,
                        width: 20,
                        color: color2,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 200,
                    child: DragTarget(
                      builder: (context, accepted, rejected) {
                        return Container(
                          height: 20,
                          width: 20,
                          color: color2,
                        );
                      },
                      onAccept: (data) {
                        context.push('/RyuPage');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            color: colorGrey,
            thickness: 5,
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 200,
                color: color2,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: size.width * 0.9,
                    color: color2,
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: Text("신성민의 페이지"),
                  ),
                  Positioned(
                    top: 120,
                    left: 10,
                    child: ElevatedButton(
                      child: const Text("Sin Page"),
                      onPressed: () {
                        context.push("/SinPage");
                      },
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              context.push("/SinPage");
                            },
                            backgroundColor: colorGrey,
                            foregroundColor: Colors.white,
                            icon: Icons.arrow_forward,
                            label: "move",
                          ),
                        ],
                      ),
                      child: Container(
                        height: 50,
                        width: 200,
                        color: color1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            color: colorGrey,
            thickness: 5,
          ),
          Column(
            children: [
              const Text("내 그룹"),
              ElevatedButton(
                child: const Text("Settlement Page"),
                onPressed: () {
                  context.push("/SettlementPage");
                },
              ),
              ElevatedButton(
                child: const Text("Gun Page"),
                onPressed: () {
                  context.push("/GunPage");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
