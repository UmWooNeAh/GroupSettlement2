import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class SettlementDetailPageSettlementer extends ConsumerStatefulWidget {
  const SettlementDetailPageSettlementer({super.key});

  @override
  ConsumerState<SettlementDetailPageSettlementer> createState() =>
      _SettlementDetailPageSettlementerState();
}

class _SettlementDetailPageSettlementerState
    extends ConsumerState<SettlementDetailPageSettlementer> {
  String settlementName = "정산 1";
  String inputName = '';
  @override
  Widget build(BuildContext context) {
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
              child: const Text(
                "그룹명",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                  child: Text(
                    settlementName,
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
                            settlementName = value;
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
                                settlementName = inputName;
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
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "정산자",
                              style: TextStyle(color: color1, fontSize: 15),
                            ),
                            Text(
                              "이름",
                              style: TextStyle(
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
                      "2023-08-19",
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
                        "국민은행 123-456789",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "류지원",
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
                        "${priceToString.format(48000)}원 ",
                        style: const TextStyle(
                          color: color1,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "/ ${priceToString.format(96000)}원",
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
                        width: size.width * 0.6,
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
                    3,
                    (index) {
                      return Column(
                        children: List.generate(
                          3,
                          (index) => Container(
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
                                      const Text(
                                        "이름1",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "${priceToString.format(12000)}원",
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
                  children: List.generate(4, (index) {
                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              "항목 ${index * index * index * index * index * index}",
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
                                      const TextSpan(
                                          text: "${1}명 ",
                                          style: TextStyle(
                                            color: color1,
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
                                  "${priceToString.format(8000)}원",
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
                        "${priceToString.format(12000)}원",
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
