import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class SettlementDetailPageSettlementer extends ConsumerStatefulWidget {
  const SettlementDetailPageSettlementer({super.key});

  @override
  ConsumerState<SettlementDetailPageSettlementer> createState() =>
      _SettlementDetailPageSettlementerState();
}

class _SettlementDetailPageSettlementerState
    extends ConsumerState<SettlementDetailPageSettlementer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("엄우네아"),
            Row(
              children: [
                const Text("정산 1"),
                GestureDetector(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("정산 이름 변경"),
                      content: const TextField(),
                      actions: [
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("변경된 이름 저장"),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("취소"),
                        ),
                      ],
                    ),
                  ),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('images/editGroupName.png'),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                          ),
                        ),
                        const Column(
                          children: [
                            Text(
                              "정산자",
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "이름",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Text("2023-08-19"),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("등록 계좌"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("국민은행 123-456789"),
                      Text("류지원"),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("금액"),
                  Row(
                    children: [
                      Text("48,000원"),
                      Text("/96,000원"),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey[200],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("정산 현황"),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Align(
                            alignment: Alignment(-0.9, 0), child: Text("0%")),
                      ),
                      Container(
                        height: 40,
                        width: size.width * 0.9 * 0.0,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey[200],
            ),
            Container(
              width: size.width,
              height: 250,
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) {
                    return Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.all(5),
                          height: 70,
                          width: 150,
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  color: colorGrey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ), //
                    );
                  }),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              height: 50,
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
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
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
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
