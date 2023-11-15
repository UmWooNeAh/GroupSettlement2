import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../class/class_settlement.dart';
import '../design_element.dart';
import '../viewmodel/GroupViewModel.dart';

class GroupSettlementListPage extends ConsumerStatefulWidget {
  const GroupSettlementListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupSettlementListPage> createState() =>
      _GroupSettlementListPageState();
}

class _GroupSettlementListPageState
    extends ConsumerState<GroupSettlementListPage> {
  bool flag = true;
  bool _isFilterClicked = false;
  Map<Settlement, bool> ischecked = {};

  checking(Settlement settlement, bool val) {
    this.ischecked[settlement] = val;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GroupViewModel gvm = ref.watch(groupProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gvm.myGroup.groupName ?? "NULL",
                                style: TextStyle(),
                              ),
                              Text("정산 목록",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              flag = !flag;
                              ischecked = {};
                            });
                          },
                          child: Container(
                              width: size.width * 0.35,
                              height: 55,
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.2, color: Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Center(
                                  child: Text("정산 합치기",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: double.infinity, height: 30),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 20,
                    child: Align(
                      alignment: Alignment(0.8, 1),
                      child: GestureDetector(
                        onTap: (){
                          _isFilterClicked = !_isFilterClicked;
                        },
                          child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "이름순",
                            style: TextStyle(
                                //fontSize:20,
                                color: Color(0xFF838383))),
                        TextSpan(
                            text: "▼",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF838383),
                            ))
                      ]))),
                    ),
                  ),
                  Column(
                      children:
                          List.generate(gvm.settlementInGroup.length, (index) {
                    Settlement settlement = gvm.settlementInGroup[index];
                    bool masterFlag =
                        gvm.userData.serviceUserId == settlement.masterUserId;
                    return settlement.isMerged!
                        ? MultipleSettlement(
                            size: size,
                            masterFlag: masterFlag,
                            settlement: settlement,
                            flag: flag)
                        : OneSettlement(
                            size: size,
                            masterFlag: masterFlag,
                            settlement: settlement,
                            flag: flag,
                            callBack: checking);
                  })),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: flag ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey, width: 2),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(color: Colors.white),
                        child: OutlinedButton(
                          onPressed: () async {
                            //gvm.mergeSettlement(stm1, stm2, newName)
                            //opacity 0이라도 버튼은 존재함 처리 필요
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: color2,
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "${this.ischecked.values.where((val) => val == true).length.toString()}개 항목 합치기",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class OneSettlement extends ConsumerStatefulWidget {
  final Size size;
  final Settlement settlement;
  final bool masterFlag;
  final bool flag;
  final Function callBack;

  const OneSettlement(
      {Key? key,
      required this.size,
      required this.settlement,
      required this.masterFlag,
      required this.flag,
      required this.callBack})
      : super(key: key);

  @override
  ConsumerState<OneSettlement> createState() => _OneSettlementState();
}

class _OneSettlementState extends ConsumerState<OneSettlement> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    var containerWidth =
        widget.flag ? widget.size.width * 0.05 : widget.size.width * 0.15;
    Color color = widget.masterFlag ? Color(0xFF07BEB8) : Color(0xFFFE5F55);
    int currentStmComplete = 0;
    DateTime dt;

    if(widget.flag){
      _isChecked = false;
    }
    widget.settlement.checkSent.forEach((key, value) {
      if (value == 3) currentStmComplete++;
    });

    dt = widget.settlement.time != null
        ? DateTime.parse(widget.settlement.time!.toDate().toString())
        : DateTime.utc(1000, 01, 01);
    final provider = ref.watch(groupProvider);
    return Column(
      children: [
        SizedBox(width: double.infinity, height: 30),
        GestureDetector(
          onTap: () {
            if(!widget.flag) {
              setState(() {
                _isChecked = !_isChecked;
                widget.callBack(widget.settlement, _isChecked);
              });
            }
            context.push("/SettlementInformation", extra: [widget.settlement, provider.myGroup, provider.userData]);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 27),
                child: AnimatedOpacity(
                  opacity: widget.flag ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Transform.scale(
                    scale: 1.7,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: color2,
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                          widget.callBack(widget.settlement, value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                margin: EdgeInsets.only(
                    left: containerWidth, right: widget.size.width * 0.05),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(width: 3, color: color),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 2,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(children: [
                  Container(
                      width: double.infinity,
                      height: 23,
                      color: color,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(widget.masterFlag ? "받을 정산" : "보낼 정산",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(DateFormat("yyyy/MM/dd").format(dt),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                          )
                        ],
                      )),
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(-0.9, 0),
                          child: Text(
                            widget.settlement.settlementName!,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.9, 0),
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
                                  text:
                                      ' / ${widget.settlement.checkSent.length}명',
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
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MultipleSettlement extends ConsumerStatefulWidget {
  final Size size;
  final bool masterFlag;
  final Settlement settlement;
  final bool flag;

  const MultipleSettlement(
      {Key? key,
      required this.size,
      required this.masterFlag,
      required this.settlement,
      required this.flag})
      : super(key: key);

  @override
  ConsumerState<MultipleSettlement> createState() => _MultipleSettlementState();
}

class _MultipleSettlementState extends ConsumerState<MultipleSettlement> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    var containerWidth =
        widget.flag ? widget.size.width * 0.05 : widget.size.width * 0.15;
    Color color = widget.masterFlag ? Color(0xFF07BEB8) : Color(0xFFFE5F55);
    int currentStmComplete = 0;
    DateTime dt;

    widget.settlement.checkSent.forEach((key, value) {
      if (value == 3) currentStmComplete++;
    });

    dt = widget.settlement.time != null
        ? DateTime.parse(widget.settlement.time!.toDate().toString())
        : DateTime.utc(1000, 01, 01);
    final provider = ref.watch(groupProvider);
    return Column(
      children: [
        const SizedBox(width: double.infinity, height: 30),
        GestureDetector(
          onTap: () {
            context.push("/SettlementInformation", extra: [widget.settlement, provider.myGroup, provider.userData]);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 27),
                child: AnimatedOpacity(
                  opacity: widget.flag ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Transform.scale(
                    scale: 1.7,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: color2,
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.45, 0),
                child: AnimatedContainer(
                  width: double.infinity,
                  height: 118,
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(
                      left: containerWidth + 50,
                      right: widget.size.width * 0.05),
                  decoration: ShapeDecoration(
                      color: Color(0xFFCECECE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Align(
                alignment: Alignment(0.22, 0),
                child: AnimatedContainer(
                  width: double.infinity,
                  height: 108,
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(
                      left: containerWidth + 25,
                      right: widget.size.width * 0.05),
                  decoration: ShapeDecoration(
                      color: Color(0xFF929292),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(
                      left: containerWidth, right: widget.size.width * 0.05),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 3, color: color),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 2,
                        offset: Offset(0, 5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        height: 23,
                        color: color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("합쳐진 정산",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(DateFormat("yyyy/MM/dd").format(dt),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                            )
                          ],
                        )),
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment(-0.9, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.settlement.settlementName,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          " 등 ${widget.settlement.mergedSettlement.length - 1}개",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF838383)))
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, 0),
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
                                    text:
                                        ' / ${widget.settlement.checkSent.length}명',
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
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
