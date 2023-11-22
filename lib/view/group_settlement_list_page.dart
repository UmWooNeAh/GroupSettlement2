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
  String realAccount = "";
  List<bool> selected = [];
  List<String> filter = ["이름순","업데이트순","새 정산 순"];
  int selectedFilter = 1;

  checking(Settlement settlement, bool val) {
    this.ischecked[settlement] = val;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GroupViewModel gvm = ref.watch(groupProvider);
    List<Settlement> stms = gvm.settlementInGroup;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 100),
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
                              _isFilterClicked = false;
                            });
                          },
                          child: Container(
                              width: size.width * 0.35,
                              height: 55,
                              decoration: ShapeDecoration(
                                  color: flag ? null : Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.2, color: Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Center(
                                  child: Text(flag ? "정산 합치기" : "합치기 취소",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: double.infinity, height: 30),
                  Column(
                      children:
                          List.generate(stms.length, (index) {
                    Settlement settlement = stms[index];
                    bool masterFlag =
                        gvm.userData.serviceUserId == settlement.masterUserId;
                    return OneSettlement(
                            size: size,
                            masterFlag: masterFlag,
                            settlement: settlement,
                            flag: flag,
                            callBack: checking);
                  })),
                  SizedBox(height: 100)
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
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFF4F4F4), width: 5),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "정산은 합치고 원래대로 되돌릴 수 없습니다",
                          style: TextStyle(
                              color: color1, fontWeight: FontWeight.w600),
                        ),
                        Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(color: Colors.white),
                            child: OutlinedButton(
                              onPressed: () async {
                                if(ischecked.length < 2) return;
                                Set<String> account = <String>{};
                                String mergeStmName = "병합 정산";
                                if (flag) return;

                                List<int> indices = [];
                                for (var entry in ischecked.entries) {
                                  if (entry.value == true) {
                                    indices.add(gvm.settlementInGroup
                                        .indexWhere((stm) => stm == entry.key));
                                    account.add(entry.key.accountInfo!);
                                    selected.add(false);
                                  }
                                }

                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text("정산 이름",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        hintText: "병합 정산 1",
                                        labelStyle:
                                            TextStyle(color: Color(0xFF838383)),
                                      ),
                                      onChanged: (value) {
                                        mergeStmName = value;
                                      },
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      SizedBox(
                                        height: 50,width: size.width*0.3,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            if (mergeStmName != null) {
                                              if (account.length > 1) {
                                                return showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "계좌 선택",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 18)),
                                                            backgroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            content: SizedBox(
                                                              height:size.height * 0.01 + (size.height * 0.05 * account.length),
                                                              child: Column(
                                                                  children: List.generate(
                                                                      account.length, (index) {
                                                                        return Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Transform.scale(
                                                                              scale:1.2,
                                                                              child: Checkbox(
                                                                                value: selected[index],
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(10)
                                                                                ),
                                                                                activeColor: color2,
                                                                                onChanged: (value){
                                                                                  setState((){
                                                                                    for(int i=0;i<selected.length;i++){
                                                                                      selected[i] = false;
                                                                                    }
                                                                                    selected[index] = !selected[index];
                                                                                    realAccount = account.toList()[index];
                                                                                  });
                                                                                }
                                                                              ),
                                                                            ),
                                                                            Text(account.toList()[index],
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 17,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                  })
                                                              ),
                                                            ),
                                                            actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            actions: [
                                                              SizedBox(
                                                                height: 50, width: size.width*0.4,
                                                                child: OutlinedButton(
                                                                  onPressed: () async{
                                                                    if(!selected.contains(true)) return;
                                                                    for(int i in indices){
                                                                      stms[i].accountInfo = realAccount;
                                                                    }
                                                                    bool isSuccessed = await gvm.mergeSettlements(indices, mergeStmName);
                                                                    if(isSuccessed){
                                                                      await gvm.settingGroupViewModel(gvm.userData, gvm.myGroup.groupId!);
                                                                    } else {
                                                                      print("Error while merging settlements");
                                                                    }
                                                                    flag = !flag;
                                                                    ischecked = {};
                                                                    selected = [];
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor: !selected.contains(true) ? Color(0xFFD9D9D9) : color1,
                                                                    side: BorderSide(
                                                                      color: !selected.contains(true) ? Color(0xFFD9D9D9) : color1,
                                                                    ),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          5),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    !selected.contains(true) ? "계좌를 선택해 주세요": "계좌 선택 완료",
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: !selected.contains(true) ? Color(0xFF838383) : Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 50, width: size.width*0.2,
                                                                child: OutlinedButton(
                                                                  onPressed: () {
                                                                    selected = [];
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                    side: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child: const Text(
                                                                    "취소",
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      );
                                                    }
                                                );
                                              } else {
                                                bool isSuccessed = await gvm.mergeSettlements(indices, mergeStmName);
                                                if(isSuccessed){
                                                  await gvm.settingGroupViewModel(gvm.userData, gvm.myGroup.groupId!);
                                                } else {
                                                  print("Error while merging settlements");
                                                }
                                                flag = !flag;
                                                ischecked = {};
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text('그룹 명은 공백이 될 수 없습니다'),
                                                duration: Duration(seconds: 3),
                                              ));
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: color2,
                                            side: const BorderSide(
                                              color: color2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: const Text(
                                            "이름 저장",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50, width: size.width*0.3,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                );
                                //bool isSuccessed = await gvm.mergeSettlements(indices, "합쳐진 정산");
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ischecked.values.where((val) => val == true).length > 1 ? color1 : Color(0xFFD9D9D9),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "${ischecked.values.where((val) => val == true).length.toString()}개 항목 합치기",
                                style: TextStyle(
                                  color: ischecked.values.where((val) => val == true).length > 1 ? Colors.white : Color(0xFF848484),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top:180, left:size.width*0.7,
              child: Padding(
                padding: EdgeInsets.only(right: size.width * 0.05),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: size.width * 0.22,
                  height: _isFilterClicked ? 105 : 25,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: _isFilterClicked ? 2 : 0,
                        color: _isFilterClicked ? Color(0xFFD9D9D9) : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Align(
                    alignment: Alignment(0.8, 1),
                    child: Container(
                      color:Colors.white,
                      child: GestureDetector(
                          onTap: () {
                            setState((){_isFilterClicked = !_isFilterClicked;});
                          },
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: filter[selectedFilter],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF838383))),
                                  TextSpan(
                                      text: "▼",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF838383),
                                      ))
                                ])),
                                Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(filter.length, (index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          _isFilterClicked = !_isFilterClicked;
                                          selectedFilter = index;
                                          gvm.sortStms(index);
                                        });
                                      },
                                      child: Text(filter[index]+'  ',
                                        style: TextStyle(
                                          color: Color(0xFF838383),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
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
    bool _canMerge = widget.masterFlag;
    var containerWidth =
        widget.flag ? widget.size.width * 0.05 : widget.size.width * 0.15;
    Color color = widget.masterFlag
        ? Color(0xFFFE5F55)
        : widget.flag
            ? Color(0xFF07BEB8)
            : Color(0xFF848484);
    int currentStmComplete = 0;
    DateTime dt;

    if (_canMerge) {
      for (var entry in widget.settlement.checkSent.entries) {
        if (entry.value == 1 || entry.value == 2) {
          _canMerge = false;
        }
      }
    }
    if (widget.flag) {
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
            if (!widget.flag) {
              setState(() {
                _isChecked = !_isChecked;
                widget.callBack(widget.settlement, _isChecked);
              });
            }
            context.push("/SettlementInformation", extra: [
              widget.settlement,
              provider.myGroup,
              provider.userData
            ]);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 27),
                child: AnimatedOpacity(
                  opacity: widget.flag ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Transform.scale(
                    scale: 1.7,
                    child: Checkbox(
                      fillColor: MaterialStateColor.resolveWith((states) {
                        if (!states.contains(MaterialState.selected) &&
                            !_canMerge) {
                          return Color(0xFFD9D9D9);
                        }
                        if (states.contains(MaterialState.selected)) {
                          return color2;
                        }
                        return Colors.white;
                      }),
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: _canMerge ? _isChecked : false,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                          if (_canMerge)
                            widget.callBack(widget.settlement, value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                    left: containerWidth, right: widget.size.width * 0.05),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(width: 3, color: _isChecked ? Color(0xFFD77872): color),
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
                child: Stack(
                  children: [
                    Column(children: [
                      Container(
                          width: double.infinity,
                          height: 23,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)
                            )
                          ),
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
                              child: widget.flag ? Text.rich(
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
                              ) : Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    _isChecked ? Container(
                      height:93, width: double.infinity,
                      color: Colors.grey.withOpacity(0.4)
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
