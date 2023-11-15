import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../class/class_settlement.dart';
import '../class/class_settlementitem.dart';
import '../class/class_settlementpaper.dart';
import '../design_element.dart';
import '../viewmodel/MainViewModel.dart';
import '../viewmodel/UserViewModel.dart';

AnimatedDigitController controller = AnimatedDigitController(1);

class mainPage extends ConsumerStatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<mainPage> createState() => _mainPageState();
}

class _mainPageState extends ConsumerState<mainPage> {
  double settlementerRes = 0;
  bool _isCalculated = false;
  bool _isFirstBuild = true;
  int maxSettlementCount = 2;
  int currentCount = 0;
  bool _isMore = false;
  List<Settlement> currentStms = [];
  List<Settlement> allStms = [];
  ScrollController scrollController = ScrollController();
  var pos;
  simpleSettlementerCal(double res) {
    this.settlementerRes = res;
    this._isCalculated = true;
    setState(() {});
  }

  reCal() {
    setState(() {
      this._isCalculated = false;
    });
  }

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      var mvm = ref.watch(mainProvider);
      await mvm.settingMainViewModel("bxxwb8xp-p90w-ppfp-bbw9-b9bwwx8bf9bf");

      scrollController.addListener(() async{
        pos = scrollController.position.pixels;
        if(!mvm.isFetchFinished) {
          if (mvm.lock && scrollController.position.maxScrollExtent * 0.7 <
              scrollController.position.pixels) {
            mvm.toggleLock();
            await mvm.fetchSettlement(mvm.settlementInfo.length, maxSettlementCount);
            await Future.delayed(Duration(milliseconds: 1000));
            mvm.toggleLock();
          }
        }
      });
    });



    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var mvm = ref.watch(mainProvider);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:50),
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 7,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(),
                    ),
                    Text("Y'EMON"),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(color: Color(0xFFF4F4F4)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 7,
                      )
                    ]),
                    child: Center(
                      child: Text("문구 들어갈 위치",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    )),
              ),
              Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                      //color: Color(0xFFF4F4F4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        BoxShadow(
                          color: Color(0xFFF4F4F4),
                          spreadRadius: -2.0,
                          blurRadius: 12.0,
                        )
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Text("단순 정산기",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 10, bottom: 10),
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: double.infinity,
                              height: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: _isCalculated ? color1 : color2,
                                      width: 3),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        blurRadius: 6)
                                  ]),
                              child: Stack(
                                children: [
                                  SimpleSettlementerRes(
                                      res: settlementerRes,
                                      notify: reCal,
                                      flag: _isCalculated),
                                  SimpleSettlementer(
                                      size: size,
                                      notify: simpleSettlementerCal,
                                      flag: _isCalculated)
                                ],
                              )),
                        )
                      ])),
              SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            width: size.width * 0.45,
                            height: 120,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xFFD9D9D9)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 6,
                                    //offset: Offset(-2,2)
                                  )
                                ]),
                          child: Stack(
                            children: [
                              Positioned(
                                left:70, top: 8,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: size.width * 0.3,
                                      height: 150,
                                      child: Image.asset(
                                        'images/getCameraYemon.png',
                                        opacity: AlwaysStoppedAnimation(.5),
                                        fit: BoxFit.cover,
                                        scale: 1,
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color:Colors.white,
                                          gradient: LinearGradient(
                                              colors:[
                                                Colors.white.withOpacity(1),
                                                Colors.white.withOpacity(0)
                                              ]
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:15,top:32),
                                child: Text("카메라로\n영수증 인식하기",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            width: size.width * 0.45,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xFFD9D9D9)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      blurRadius: 5)
                                ]),
                            child: Stack(
                              children: [
                                Positioned(
                                  top:30,left:105,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: size.width * 0.3,
                                          height: 100,
                                          child: Image.asset(
                                            'images/dynamicYemonLogo.png',
                                            opacity: AlwaysStoppedAnimation(.5),
                                            //fit: BoxFit.cover,
                                            scale: 0.1,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text("Dynamic Yemon",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Color(0xFF848484))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "최소 횟수 정산,\n",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Color(0xFF848484))),
                                                TextSpan(
                                                    text: "곧 만나요",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Color(0xFF848484)))
                                              ],
                                            ),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(thickness: 1, color: Color(0xFFD9D9D9)),
              ),
              SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    context
                        .go("/GroupSelectPage/${mvm.userData.serviceUserId}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFD9D9D9))),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("      "),
                            Text("내가 속한 그룹 확인하기",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Icon(Icons.navigate_next),
                          ],
                        ))),
                  )),
              SizedBox(height: 10),
              Divider(thickness: 5, color: Color(0xFFF4F4F4)),
              //SizedBox(height:100),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 10,left: 10),
                      child: Text("최근 정산",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top:20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mvm.settlementInfo.length == 0 ? 1 : mvm.settlementInfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(mvm.settlementInfo.length != 0) {
                          Settlement settlement = mvm.settlementInfo.keys
                              .toList()[index];
                          return RecentSettlement(size: size,
                              settlement: settlement);
                          }
                        },
                    ),
                    !mvm.lock ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
                    SizedBox(height:mvm.isFetchFinished ? 0 : 60)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: true,
      ),
    );
  }
}

class SimpleSettlementer extends StatefulWidget {
  final Size size;
  final Function notify;
  final bool flag;

  const SimpleSettlementer(
      {Key? key, required this.size, required this.notify, required this.flag})
      : super(key: key);

  @override
  State<SimpleSettlementer> createState() => _SimpleSettlementerState();
}

class _SimpleSettlementerState extends State<SimpleSettlementer> {
  int _currentNum = 1;
  TextEditingController price = TextEditingController(text: "990,000");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        curve: Curves.fastEaseInToSlowEaseOut,
        duration: Duration(milliseconds: widget.flag ? 300 : 700),
        width: widget.flag ? 0 : widget.size.width - 24,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: widget.size.width* 0.4,
                  child: Column(
                    children: [
                      Text("총 금액",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          )),
                      Container(
                        height:42,
                        child: TextField(
                          expands: false,
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          controller: price,
                          onChanged: (value) {
                            setState(() {
                              if (value == '') {
                                price.text = '0';
                              } else {
                                price.text = priceToString
                                    .format(priceToString.parse(value));
                              }
                            });
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(top: 7),
                              child: Text(
                                "원",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: widget.size.width * 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(right: widget.size.width * 0.07),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const Text("사람 수",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                          Stack(
                            children: [
                              const SizedBox(height: 100),
                              Positioned(
                                top: -50,
                                child: SizedBox(
                                  width: 60,
                                  height: 100,
                                  child: NumberPicker(
                                    //axis:Axis.horizontal,
                                    value: _currentNum,
                                    minValue: 1,
                                    maxValue: 99,
                                    haptics: true,
                                    onChanged: (value) {
                                      setState(() => _currentNum = value);
                                    },
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 18),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(55, 15, 0, 0),
                                child: Text("명"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 5),
                  child: SizedBox(
                    width: widget.size.width*0.27,
                    height: 60,
                    child: OutlinedButton(
                        onPressed: () {
                          if (_currentNum != 0) {
                            widget.notify(
                                priceToString.parse(price.text) / _currentNum);
                          } else {
                            widget.notify(0);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF454545),
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text("계산하기",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleSettlementerRes extends StatefulWidget {
  final Function notify;
  final double res;
  final bool flag;

  const SimpleSettlementerRes(
      {Key? key, required this.notify, required this.res, required this.flag})
      : super(key: key);

  @override
  State<SimpleSettlementerRes> createState() => _SimpleSettlementerResState();
}

class _SimpleSettlementerResState extends State<SimpleSettlementerRes> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: AnimatedContainer(
          curve: Curves.fastEaseInToSlowEaseOut,
          duration: Duration(milliseconds: widget.flag ? 700 : 300),
          width: widget.flag ? 1000 : 0,
          height: 100,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 20,
                child: Text("1인당",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Positioned(
                  top: 25,
                  left: 80,
                  child: AnimatedDigitWidget(
                    controller: controller,
                    fractionDigits: 2,
                    duration: Duration(seconds: 1),
                    value: widget.res,
                    enableSeparator: true,
                    suffix: "원",
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: color1,
                    ),
                  )
                  // child: Text("${priceToString.format(widget.res)}원",
                  //   textAlign: TextAlign.start,
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w600,
                  //     color: color1,
                  //   )
                  // ),
                  ),
              Positioned(
                top: 13,
                left: 265,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 110,
                      child: OutlinedButton(
                        onPressed: () {
                          widget.notify();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFFF4F4F4),
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: null,
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 10,
                      child: Text("다시 계산하기",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class RecentSettlement extends ConsumerStatefulWidget {
  final Size size;
  final Settlement settlement;
  const RecentSettlement(
      {Key? key, required this.size, required this.settlement})
      : super(key: key);

  @override
  ConsumerState<RecentSettlement> createState() => _RecentSettlementState();
}

class _RecentSettlementState extends ConsumerState<RecentSettlement> {
  List<SettlementPaper> papers = [];
  double currentMoney = 1;
  late double totalPrice;
  late double sendMoney;
  bool _didSend = true;
  DateTime dt = DateTime.now();
  bool masterFlag = false;
  double barSize = 2;

  @override
  Widget build(BuildContext context) {
    var mvm = ref.watch(mainProvider);
    bool masterFlag =
        widget.settlement.masterUserId == mvm.userData.serviceUserId;
    barSize = widget.size.width * 0.67;
    currentMoney = mvm.getCurrentMoney(widget.settlement);
    totalPrice = mvm.getTotalPrice(widget.settlement);
    if (!masterFlag) {
      sendMoney = mvm.getSendMoney(widget.settlement);
      _didSend = widget.settlement.checkSent[mvm.userData.serviceUserId] == 2;
    }
    dt = widget.settlement.time != null
        ? DateTime.parse(widget.settlement.time!.toDate().toString())
        : DateTime.utc(1000, 01, 01);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.go(
                "/SettlementDetailPage/${widget.settlement.settlementId}/${mvm.getGroupName(widget.settlement)}/${mvm.userData.serviceUserId}");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: (widget.size.width - 12) * 0.92 ,
                  height: 165,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: masterFlag ? color1 : color2,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          blurRadius: 6,
                          spreadRadius: 0.0,
                        )
                      ]),
                  child: Stack(
                    children: [
                      Positioned(
                        right:0,
                        bottom: 135,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 25),
                          child: Text(DateFormat("yyyy/MM/dd").format(dt),
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: masterFlag ? "받을 정산\n" : "보낼 정산\n",
                                    style: TextStyle(
                                        color: masterFlag ? color1 : color2,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: widget.settlement.settlementName,
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w700))
                              ])),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 5),
                                child: Text(mvm.getGroupName(widget.settlement),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 65),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(),
                              ),
                              Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(masterFlag ? "받을 금액" : "보낼 금액",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                          masterFlag
                                              ? priceToString.format(currentMoney)
                                              : _didSend
                                                  ? "송금 완료"
                                                  : priceToString.format(sendMoney),
                                          style: TextStyle(
                                              color: masterFlag ? color1 : color2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                    ),
                                    Text(
                                        masterFlag
                                            ? " / ${priceToString.format(totalPrice)}"
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Text(
                                        masterFlag
                                            ? currentMoney == totalPrice
                                                ? "정산이 완료되었습니다"
                                                : ""
                                            : widget.settlement.checkSent[mvm
                                                        .userData.serviceUserId] ==
                                                    2
                                                ? ""
                                                : "항목을 눌러 송금 확인하기",
                                        //정산 완료 확인 체크필요
                                        style: TextStyle(
                                          color: masterFlag ? color1 : color2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    )
                                  ]),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(),
                              ),
                            ],
                          )),
                      Positioned(
                        top: 130,
                        left: 10,
                        child: Row(
                          children: [
                            Text("정산 현황",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600)),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: barSize,
                                    height: 12,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x4C000000),
                                            blurRadius: 1,
                                          )
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: totalPrice != 0
                                        ? barSize * (currentMoney / totalPrice)
                                        : barSize,
                                    height: 12,
                                    decoration: BoxDecoration(
                                        color: totalPrice != 0
                                            ? masterFlag
                                                ? color1
                                                : color2
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x4C000000),
                                            blurRadius: 7,
                                          )
                                        ]),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Stack(
                children: [
                  Container(
                      width: 12,
                      height: 165,
                      decoration: BoxDecoration(
                          color: masterFlag ? color1 : color2,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              blurRadius: 6,
                              spreadRadius: 0.0,
                            ),
                          ]
                      )),
                  Positioned(
                      left: -7,
                      top: 70,
                      child: Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ))
                ],
              )
            ],
          ),
        ),
        SizedBox(height:20)
      ],
    );
  }
}
