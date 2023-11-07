import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:groupsettlement2/viewmodel/SettlementCheckViewModel.dart';
import 'package:intl/intl.dart';

import '../class/class_user.dart';

class SettlementDetailPage extends ConsumerStatefulWidget {
  const SettlementDetailPage(
      {super.key,
      required this.settlementId,
      required this.groupname,
      required this.userId});
  final String settlementId;
  final String groupname;
  final String userId;

  @override
  ConsumerState<SettlementDetailPage> createState() =>
      _SettlementDetailPageState();
}

class _SettlementDetailPageState extends ConsumerState<SettlementDetailPage> {
  late String settlementId;
  late String groupname;
  late String userId;
  bool isFirstBuild = true;
  bool isMaster = true;

  @override
  void initState() {
    super.initState();

    settlementId = widget.settlementId;
    groupname = widget.groupname;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmCheckProvider);

    /*
    if (isFirstBuild) {
      provider
          .settingSettlementCheckViewModel(settlementId, groupname, userId)
          .then((value) {
        isMaster = (provider.settlement.masterUserId == userId);
      });

      isFirstBuild = false;
    }

     */

    Future<bool> refreshing() async {
      if(isFirstBuild) {
        isFirstBuild = false;
        await provider.settingSettlementCheckViewModel(settlementId,groupname,userId);
        return true;
      }
      return false;
    }

    return FutureBuilder(
        future: refreshing(),
        builder: (context,snapshot){
          if(snapshot.hasData == false){
            return Container(
              width: 100, height: 100,
              child: CircularProgressIndicator()
            );
          }
          return isMaster
          // ? SettlementDetailPageSettlementer(
          //   userId: userId,
          // )
          // : SettlementDetailPageSender(
          //     userId: userId,
          //   );
              ? SettlementDetailPageSender(
            userId: userId,
          )
              : SettlementDetailPageSettlementer(
            userId: userId,
          );
    });
    /*
    return isMaster
        // ? SettlementDetailPageSettlementer(
        //   userId: userId,
        // )
        // : SettlementDetailPageSender(
        //     userId: userId,
        //   );
        ? SettlementDetailPageSender(
            userId: userId,
          )
        : SettlementDetailPageSettlementer(
            userId: userId,
          );

     */
  }
}

class SettlementDetailPageSettlementer extends ConsumerStatefulWidget {
  const SettlementDetailPageSettlementer({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<SettlementDetailPageSettlementer> createState() =>
      _SettlementDetailPageSettlementerState();
}

class _SettlementDetailPageSettlementerState
    extends ConsumerState<SettlementDetailPageSettlementer> {
  String inputName = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmCheckProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Text(
                provider.groupName ?? "default group name",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                  child: Text(
                    provider.settlement.settlementName ?? "",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("정산 이름 변경"),
                      content: TextField(
                        onChanged: (value) {
                          inputName = value;
                        },
                        onSubmitted: (value) {
                          setState(() {
                            provider.settlement.settlementName = value;
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
                                provider.settlement.settlementName = inputName;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color1,
                              side: const BorderSide(
                                color: color1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "변경된 이름 저장",
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
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: Image.asset('images/editGroupName.png'),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "정산자",
                              style: TextStyle(color: color1, fontSize: 15),
                            ),
                            SizedBox(
                              width: 130,
                              child: Text(
                                provider.masterName ?? "이름",
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      DateFormat("yyyy/MM/dd").format(DateTime.parse(
                          provider.settlement.time?.toDate().toString() ??
                              "1000-01-01")),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "등록 계좌",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        provider.settlement.accountInfo ??
                            "account info is null",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        provider.masterName ?? "",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "금액",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${provider.settlement.checkSent.isEmpty ? priceToString.format(0) : priceToString.format(provider.settlement.checkSent.keys.toList().map((key) {
                            if (provider.settlement.checkSent[key] == 3) {
                              return provider
                                      .settlementPapers[key]?.totalPrice ??
                                  0;
                            } else {
                              return 0;
                            }
                          }).reduce((value, element) => value + element))}원 ",
                        style: const TextStyle(
                          color: color1,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "/ ${priceToString.format(provider.settlement.totalPrice)}원",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey[200],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      "정산 현황",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        width: size.width,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              inset: true,
                            ),
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              inset: true,
                            ),
                          ],
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Container(
                        height: 40,
                        width:
                            size.width * provider.settlement.checkSent.length !=
                                    0
                                ? provider.settlement.checkSent.values
                                        .toList()
                                        .where((number) => number == 3)
                                        .toList()
                                        .length /
                                    provider.settlement.checkSent.length
                                : 0,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: size.width,
                        child: Align(
                            alignment: const Alignment(-0.9, 0.0),
                            child: Text(
                              "${size.width * provider.settlement.checkSent.length != 0 ? provider.settlement.checkSent.values.toList().where((number) => number == 3).toList().length / provider.settlement.checkSent.length * 100 : 0}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 3,
              color: Colors.grey[300],
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width,
              height: 260,
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    (provider.settlementPapers.length - 1) ~/ 3 + 1,
                    (index) {
                      return Column(
                        children: List.generate(
                          min(provider.settlementPapers.length - index * 3, 3),
                          (iindex) => Container(
                            margin: const EdgeInsets.all(5),
                            height: 70,
                            width: 140,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 50,
                                  height: 50,
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        provider.settlementPapers.values
                                                .toList()[index * 3 + iindex]
                                                .userName ??
                                            "user",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "${priceToString.format(provider.settlementPapers.values.toList()[index * 3 + iindex].totalPrice)}원",
                                        style: const TextStyle(
                                          color: color1,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ), //
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 3,
              color: Colors.grey[300],
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              height: 60,
              width: size.width,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: color1,
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "정산 마감하기",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                    color: color1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment(1, 0.0),
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: Text(
                        "전체 정산 내역 관리",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              height: 3,
              color: Colors.grey[300],
            ),
            Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    width: size.width,
                    child: const Text(
                      "나의 정산서",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    )),
                Column(
                  children: List.generate(
                      provider.settlementPapers[widget.userId]?.settlementItems
                              .length ??
                          0, (index) {
                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              provider.settlementItems[widget.userId]?[index]
                                      .menuName ??
                                  "menu",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              "${priceToString.format(provider.settlementItems[widget.userId]?[index].price ?? 100)}원",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          "총 금액",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Text(
                        "${priceToString.format(provider.settlementPapers[widget.userId]?.totalPrice ?? 0)}원",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: color1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 3,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              height: 60,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment(1, 0.0),
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: Text(
                        "등록된 영수증 확인",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: false,
      ),
    );
  }
}

class SettlementDetailPageSender extends ConsumerStatefulWidget {
  const SettlementDetailPageSender({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<SettlementDetailPageSender> createState() =>
      _SettlementDetailPageSenderState();
}

class _SettlementDetailPageSenderState
    extends ConsumerState<SettlementDetailPageSender> {
  String inputName = '';

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmCheckProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Text(
                provider.groupName ?? "default group name",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              width: size.width,
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
              child: Text(
                provider.settlement.settlementName ?? "default settlement name",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "정산자",
                              style: TextStyle(color: color2, fontSize: 15),
                            ),
                            Text(
                              provider.masterName ?? "",
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      DateFormat("yyyy/MM/dd").format(DateTime.parse(
                          provider.settlement.time?.toDate().toString() ??
                              "1000-01-01")),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "등록 계좌",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        provider.settlement.accountInfo ??
                            "account info is null",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        provider.masterName ?? "",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "금액",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${provider.settlement.checkSent.isEmpty ? priceToString.format(0) : priceToString.format(provider.settlement.checkSent.keys.toList().map((key) {
                            if (provider.settlement.checkSent[key] == 3) {
                              return provider
                                      .settlementPapers[key]?.totalPrice ??
                                  0;
                            } else {
                              return 0;
                            }
                          }).reduce((value, element) => value + element))}원 ",
                        style: const TextStyle(
                          color: color2,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "/ ${priceToString.format(provider.settlement.totalPrice)}원",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey[200],
            ),
            Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    width: size.width,
                    child: const Text(
                      "나의 정산서",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    )),
                Column(
                  children: List.generate(
                      provider.settlementPapers[widget.userId]?.settlementItems
                              .length ??
                          0, (index) {
                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              provider.settlementItems[widget.userId]?[index]
                                      .menuName ??
                                  "menu",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "${provider.settlementItems[widget.userId]?[index].menuCount}명 ",
                                          style: const TextStyle(
                                            color: color2,
                                            fontSize: 17,
                                          )),
                                      TextSpan(
                                        text: "/ ${4}명",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "${priceToString.format(80000000)}원",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          "총 금액",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Text(
                        "${priceToString.format(provider.settlementPapers[widget.userId]?.totalPrice ?? 0)}원",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: color2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              height: 60,
              width: size.width,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: color2,
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "송금 완료 알리기",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey[200],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      "정산 현황",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        width: size.width,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              inset: true,
                            ),
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              inset: true,
                            ),
                          ],
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: size.width * 0.6,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: size.width,
                        child: const Align(
                            alignment: Alignment(-0.9, 0.0),
                            child: Text(
                              "${60}%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    inset: true,
                    color: Color(0xffcccccc),
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                  BoxShadow(
                    inset: true,
                    color: Color(0xffcccccc),
                    blurRadius: 2,
                    offset: Offset(2, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    (provider.settlementPapers.length - 1) ~/ 3 + 1,
                    (index) {
                      return Column(
                        children: List.generate(
                          min(provider.settlementPapers.length - index * 3, 3),
                          (iindex){
                              return FutureBuilder(
                                future: ServiceUser().getUserByUserId(provider.settlementPapers.values
                                    .toList()[index * 3 + iindex]
                                    .serviceUserId ?? ""),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData == false){
                                    return CircularProgressIndicator();
                                  } else {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      height: 70,
                                      width: 140,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            width: 50,
                                            height: 50,
                                            child: ClipOval(
                                              child: Container(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  snapshot.data?.name ?? ""
                                                  ,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  "${priceToString.format(
                                                      provider.settlementPapers
                                                          .values
                                                          .toList()[index * 3 +
                                                          iindex]
                                                          .totalPrice)}원",
                                                  style: TextStyle(
                                                    color: provider.settlement
                                                        .checkSent[provider
                                                        .settlementPapers.keys
                                                        .toList()[
                                                    index * 3 + iindex]] ==
                                                        3
                                                        ? color2
                                                        : colorGrey,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                              );

                            }
                        ), //
                      );

                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              height: 60,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                    color: color2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment(1, 0.0),
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: Text(
                        "전체 정산 내역 확인",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: false,
      ),
    );
  }
}
