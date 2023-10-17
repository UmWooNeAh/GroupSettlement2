import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../class/class_settlement.dart';
import '../viewmodel/GroupViewModel.dart';

class groupSettlementListPage extends ConsumerStatefulWidget {
  const groupSettlementListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<groupSettlementListPage> createState() => _groupSettlementListPageState();
}

class _groupSettlementListPageState extends ConsumerState<groupSettlementListPage> {
  var _containerWidth;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GroupViewModel gvm = ref.watch(groupProvider.notifier);
    _containerWidth = flag ? size.width*0.05 : size.width*0.15;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width:size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(gvm.myGroup.groupName ?? "NULL",
                      style:TextStyle(

                      ),
                    ),
                    Text("정산 목록",
                      style:TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.w700
                      )
                    ),
                  ]
                ),
                SizedBox(width: size.width * 0.35),
                GestureDetector(
                  onTap:(){
                    setState((){
                      flag = !flag;
                    });
                  },
                  child: Container(
                    width: size.width * 0.35, height: 55,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.2, color:Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    child:Center(
                      child: Text("정산 합치기",
                        style:TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        )
                      )
                    )
                  ),
                ),
                SizedBox(width:size.width * 0.05)
              ],
            ),
            SizedBox(width: double.infinity,height: 30),
            Align(
              alignment: Alignment(0.8,1),
              child: GestureDetector(
                child:Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "이름순",
                        style: TextStyle(
                          //fontSize:20,
                          color: Color(0xFF838383)
                        )
                      ),
                      TextSpan(
                        text: "▼",
                        style: TextStyle(
                          fontSize:15,
                          color: Color(0xFF838383),
                        )
                      )
                    ]
                  )
                )
              ),
            ),
            Column(
              children:List.generate(gvm.settlementInGroup.length, (index){
                Settlement settlement = gvm.settlementInGroup[index];
                bool masterFlag = gvm.userData.serviceUserId == settlement.masterUserId;
                return settlement.isMerged! ? multipleSettlement(containerWidth: _containerWidth, size: size, masterFlag : masterFlag, settlement: settlement)
                :oneSettlement(containerWidth: _containerWidth, size: size, masterFlag: masterFlag, settlement: settlement);
              })
            )
          ],
        ),
      )
    );
  }
}

class oneSettlement extends StatefulWidget {
  final containerWidth;
  final Size size;
  final Settlement settlement;
  final bool masterFlag;
  const oneSettlement({Key? key, required this.containerWidth, required this.size, required this.settlement, required this.masterFlag}) : super(key: key);

  @override
  State<oneSettlement> createState() => _oneSettlementState();
}

class _oneSettlementState extends State<oneSettlement> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.masterFlag ? Color(0xFF07BEB8) : Color(0xFFFE5F55);
    int currentStmComplete = 0;
    DateTime dt;

    widget.settlement.checkSent.forEach((key, value) {
      if(value == 3) currentStmComplete++;
    });

    dt = widget.settlement.time != null ? DateTime.parse(widget.settlement.time!.toDate().toString()) : DateTime.utc(1000,01,01);

    return Column(
      children: [
        SizedBox(width:double.infinity,height:30),
        GestureDetector(
          onTap:(){
            //context.push("/settlementDetailPage");
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            margin: EdgeInsets.only(left:widget.containerWidth,right:widget.size.width*0.05),
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
                        padding: const EdgeInsets.only(left:10),
                        child: Text(widget.masterFlag ? "받을 정산" : "보낼 정산",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:10),
                        child: Text(DateFormat("yyyy/MM/dd").format(dt),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      )
                    ],
                  )
              ),
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                ),
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
                              text: ' / ${widget.settlement.checkSent.length}명',
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
    );
  }
}

class multipleSettlement extends StatefulWidget {
  final containerWidth;
  final Size size;
  final bool masterFlag;
  final Settlement settlement;
  const multipleSettlement({Key? key, required this.containerWidth, required this.size, required this.masterFlag, required this.settlement}) : super(key: key);

  @override
  State<multipleSettlement> createState() => _multipleSettlementState();
}

class _multipleSettlementState extends State<multipleSettlement> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.masterFlag ? Color(0xFF07BEB8) : Color(0xFFFE5F55);
    int currentStmComplete = 0;
    DateTime dt;

    widget.settlement.checkSent.forEach((key, value) {
      if(value == 3) currentStmComplete++;
    });

    dt = widget.settlement.time != null ? DateTime.parse(widget.settlement.time!.toDate().toString()) : DateTime.utc(1000,01,01);

    return Column(
      children: [
        SizedBox(width:double.infinity,height:30),
        GestureDetector(
          onTap:(){
            //context.push("/settlementDetailPage");
          },
          child: Stack(
            children: [
              Align(
                alignment:Alignment(0.45,0),
                child: AnimatedContainer(
                  width: double.infinity,
                  height: 118,
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(left:widget.containerWidth+50,right:widget.size.width*0.05),
                  decoration: ShapeDecoration(
                      color: Color(0xFFCECECE),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Align(
                alignment:Alignment(0.22,0),
                child: AnimatedContainer(
                  width: double.infinity,
                  height: 108,
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(left:widget.containerWidth+25,right:widget.size.width*0.05),
                  decoration: ShapeDecoration(
                      color: Color(0xFF929292),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.only(left:widget.containerWidth,right:widget.size.width*0.05),
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
                              padding: const EdgeInsets.only(left:10),
                              child: Text("합쳐진 정산",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Text(DateFormat("yyyy/MM/dd").format(dt),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment(-0.9, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:widget.settlement.settlementName,
                                    style: TextStyle(
                                        fontSize: 25, fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:" 등 ${widget.settlement.mergedSettlement.length - 1}개",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:Color(0xFF838383)
                                      )
                                  )
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
                                    text: ' / ${widget.settlement.checkSent.length}명',
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


