import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/GroupViewModel.dart';
import 'package:intl/intl.dart';
import '../class/class_settlement.dart';
import '../class/class_user.dart';
import '../design_element.dart';

class GroupMainPage extends ConsumerStatefulWidget {
  final List<dynamic> info;
  const GroupMainPage({Key? key, required this.info}) : super(key: key);

  @override
  ConsumerState<GroupMainPage> createState() => _GroupMainPageState();
}

class _GroupMainPageState extends ConsumerState<GroupMainPage> {
  final bottomSheetSliderChangeNotifierProvider =
      ChangeNotifierProvider<BottomSheetSlider>((ref) => BottomSheetSlider());

  bool isFirst = true;

  int i = 0;
  @override
  Widget build(BuildContext context) {
    final gvm = ref.watch(groupProvider);
    Size size = MediaQuery.of(context).size;
    if (isFirst) {
      Future(() {
        gvm.settingGroupViewModel(widget.info[0], widget.info[1]);
      });
      ref
          .watch(bottomSheetSliderChangeNotifierProvider.notifier)
          .setBottomSheetSlider(0.0, 0.0, size.height * 0.7);
      isFirst = false;
    }

    String commonStmName = "null";
    final bottomsheetValue = ref.watch(bottomSheetSliderChangeNotifierProvider);

    Map<String, int> countMap = Map<String, int>();
    gvm.settlementInGroup.forEach((settlement) {
      if (countMap.containsKey(settlement.masterUserId)) {
        countMap[settlement.masterUserId!] =
            countMap[settlement.masterUserId!]! + 1;
      } else {
        countMap[settlement.masterUserId!] = 1;
      }
    });

    String mostCommonName = "null";
    int mostCommonCount = 0;

    countMap.forEach((name, count) {
      if (count > mostCommonCount) {
        mostCommonCount = count;
        mostCommonName = name;
      }
    });

    gvm.serviceUsers.forEach((user) {
      if (user.serviceUserId == mostCommonName) commonStmName = user.name!;
    });

    String inputName = '';
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SizedBox(height: 50),
                  const Text(
                    "그룹",
                    style: TextStyle(
                        color: Color(0xFF454545),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 0),
                  ),
                  Row(children: [
                    Text(
                      gvm.myGroup.groupName ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 0),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("그룹 이름 변경"),
                          content: TextField(
                            onChanged: (value) {
                              inputName = value;
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
                                    gvm.updateGroup(
                                        gvm.myGroup.groupId!, inputName);
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
                                  "변경된 이름 저장",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
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
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: Image.asset('images/editGroupName.png'),
                      ),
                    )
                  ]),
                  const SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "진행 중인 정산",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          const TextSpan(
                            text: "   ",
                          ),
                          TextSpan(
                            text: gvm.settlementInGroup.length.toString(),
                            style: const TextStyle(
                              color: Color(0xFFFE5F55),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ])),
                        TextButton(
                          onPressed: () {
                            context.push(
                                "/GroupSelectPage/GroupMainPage/GroupSettlementListPage");
                          },
                          child: const Text(
                            '자세히 보기 >',
                            style: TextStyle(
                              color: Color(0xFF454545),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        )
                      ]),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(gvm.settlementInGroup.length,
                            (index) {
                      Settlement settlement = gvm.settlementInGroup[index];
                      return StmItem(
                          size: size,
                          masterId: settlement.masterUserId!,
                          userId: gvm.userData.serviceUserId!,
                          settlement: settlement);
                    })),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Divider(thickness: 5, color: Color(0xFFF4F4F4)),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Container(
                      width: size.width * 0.95,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFDADADA)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${gvm.myGroup.groupName} 그룹에서 가장 많이 \n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: '정산',
                              style: TextStyle(
                                color: Color(0xFFFE5F55),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: '을 진행한 사람은 ${commonStmName}님 입니다',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // context.push();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Container(
                        width: size.width * 0.95,
                        height: 65,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("새 정산 만들기",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF454545),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    bottomsheetValue.updateHeight(-details.delta.dy);
                  },
                  onVerticalDragEnd: (details) {
                    bottomsheetValue.updateOpenState();
                  },
                  child: Container(
                    height: 60,
                    width: size.width,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Colors.black45,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 20,
                            left: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "그룹원",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * 0.65),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: "${gvm.serviceUsers.length} ",
                                        style: TextStyle(
                                          color: Color(0xFFFE5F55),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    TextSpan(
                                        text: "명",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ])),
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.topCenter,
                          child: bottomsheetValue.isOpen
                              ? const Icon(Icons.keyboard_arrow_down_outlined)
                              : const Icon(Icons.keyboard_arrow_up_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProvider.notifier)
                        .updateHeight(-details.delta.dy);

                    setState(() {});
                  },
                  onVerticalDragEnd: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProvider.notifier)
                        .updateOpenState();
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: (bottomsheetValue.currentHeight -
                                    bottomsheetValue.previousHeight)
                                .abs() >
                            3
                        ? const Duration(milliseconds: 300)
                        : const Duration(),
                    curve: Curves.decelerate,
                    height: bottomsheetValue.currentHeight,
                    width: size.width,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                  width: double.infinity,
                                  height: 350,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Column(
                                        children: List.generate(
                                            (gvm.serviceUsers.length / 4)
                                                    .toInt() +
                                                1, (index) {
                                          return Row(
                                            children:
                                                List.generate(4, (innerIndex) {
                                              try {
                                                return oneUser(
                                                    flag: false,
                                                    user: gvm.serviceUsers[
                                                        index * 4 +
                                                            innerIndex]);
                                              } on RangeError catch (e) {
                                                return SizedBox.shrink();
                                              }
                                            }),
                                          );
                                        }),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(height: 110),
                            Container(
                              width: double.infinity,
                              height: 60,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      width: double.infinity,
                                      height: 80,
                                      decoration: ShapeDecoration(
                                          color: Color(0xFF07BEB8),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      child: Center(
                                          child: Text("Yemon 친구 목록에서 인원 추가",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)))),
                                ),
                              ),
                            ),
                            Divider(thickness: 10, color: Color(0xFFF4F4F4)),
                            Container(
                                width: double.infinity,
                                height: 60,
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Container(
                                        width: double.infinity,
                                        height: 55,
                                        decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        child: GestureDetector(
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text(
                                                  "추가할 사용자의 이름을 입력해주세요",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18)),
                                              content: TextField(
                                                decoration: InputDecoration(
                                                  hintText: "사용자 1",
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFF838383)),
                                                ),
                                                onChanged: (value) {
                                                  inputName = value;
                                                },
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              actions: [
                                                SizedBox(
                                                  height: 50,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        ServiceUser user =
                                                            ServiceUser();
                                                        if (inputName != null) {
                                                          gvm.addByDirect(
                                                              inputName!);
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                '사용자명은 공백이 될 수 없습니다'),
                                                            duration: Duration(
                                                                seconds: 3),
                                                          ));
                                                        }
                                                      });
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor: color2,
                                                      side: const BorderSide(
                                                        color: color2,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "인원 추가",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      side: const BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "취소",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text("직접 인원 추가",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        )),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: true,
      ),
    );
  }
}

class StmItem extends ConsumerStatefulWidget {
  final Size size;
  final String masterId;
  final String userId;
  final Settlement settlement;
  const StmItem(
      {Key? key,
      required this.size,
      required this.masterId,
      required this.userId,
      required this.settlement})
      : super(key: key);

  @override
  ConsumerState<StmItem> createState() => _StmItemState();
}

class _StmItemState extends ConsumerState<StmItem> {
  @override
  Widget build(BuildContext context) {
    bool masterFlag = widget.settlement.masterUserId == widget.userId;
    Color color =
        masterFlag ? const Color(0xFF07BEB8) : const Color(0xFFFE5F55);
    int currentStmComplete = 0;
    DateTime dt;

    widget.settlement.checkSent.forEach((key, value) {
      if (value == 2) currentStmComplete++;
    });

    dt = widget.settlement.time != null
        ? DateTime.parse(widget.settlement.time!.toDate().toString())
        : DateTime.utc(1000, 01, 01);
    final gvm = ref.watch(groupProvider);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context.push(
                "/SettlementInformationPage", extra: [widget.settlement, gvm.myGroup, gvm.userData]);
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(width: 3, color: color),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 5,
                  offset: Offset(0, 5),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(children: [
              Container(
                  width: widget.size.width * 0.4,
                  height: 23,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Text(masterFlag ? "받을 정산" : "보낼 정산",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)))),
              Container(
                width: widget.size.width * 0.4,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        widget.settlement.settlementName!,
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.9, 0.65),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: currentStmComplete.toString(),
                              style: TextStyle(
                                color: color,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: " / " +
                                  widget.settlement.checkSent.length.toString(),
                              style: TextStyle(
                                color: Color(0xFF838383),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.9, 0.9),
                      child: Text(
                        DateFormat("yyyy/MM/dd").format(dt),
                        style: TextStyle(
                          color: Color(0xFF838383),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        SizedBox(width: 15)
      ],
    );
  }
}

class oneUser extends StatefulWidget {
  final bool flag;
  final ServiceUser user;

  const oneUser({Key? key, required this.flag, required this.user})
      : super(key: key);

  @override
  State<oneUser> createState() => _oneUserState();
}

class _oneUserState extends State<oneUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Container(
        width: 60,
        height: 120,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                color: Color(0xFF838383),
                shape: OvalBorder(),
              ),
            ),
            SizedBox(height: 5),
            Text(widget.user.name!,
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text(widget.flag ? "직접 추가함" : "",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF838383),
                ))
          ],
        ),
      ),
    );
  }
}

class BottomSheetSlider extends ChangeNotifier {
  double currentHeight = 600;
  double previousHeight = 0;
  double closedHeight = 600;
  double openedHeight = 200;
  bool isOpen = false;

  void setBottomSheetSlider(initial, closed, opened) {
    currentHeight = initial;
    closedHeight = closed;
    openedHeight = opened;
  }

  void updateHeight(double updateHeight) {
    previousHeight = currentHeight;

    if (currentHeight + updateHeight <= openedHeight &&
        currentHeight + updateHeight >= closedHeight) {
      currentHeight += updateHeight;
    }
    notifyListeners();
  }

  void updateOpenState() {
    if (!isOpen) {
      if (currentHeight - previousHeight > 1.5 ||
          currentHeight - closedHeight > 50) {
        isOpen = true;
        currentHeight = openedHeight;
      } else {
        currentHeight = closedHeight;
      }
    } else {
      if (currentHeight - previousHeight < -1.5 ||
          currentHeight - openedHeight < -50) {
        isOpen = false;
        currentHeight = closedHeight;
      } else {
        currentHeight = openedHeight;
      }
    }
    notifyListeners();
  }
}
