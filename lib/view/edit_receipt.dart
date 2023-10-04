import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class EditReceiptPage extends ConsumerStatefulWidget {
  const EditReceiptPage({super.key});

  @override
  ConsumerState<EditReceiptPage> createState() => _EditReceiptState();
}

class _EditReceiptState extends ConsumerState<EditReceiptPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "스캔된 영수증 ",
                ),
                TextSpan(text: "내용이 맞는지 "),
                TextSpan(text: "확인"),
                TextSpan(text: "해 주세요."),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFCCCCCC),
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Color(0xFFCCCCCC),
                    blurRadius: 2,
                    offset: Offset(2, -2),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text("영수증 1"),
                  const Text("거래일시 : ${2023}.${7}.${27} ${"19:58:23"}"),
                  const Text("업체명: 달빛한모금 경북대점"),
                  const Row(
                    children: [
                      Text("메뉴"),
                      Text("수량"),
                      Text("가격"),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          10,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("짜장면"),
                                  Text("$index"),
                                  Text(
                                    "${priceToString.format(index * 10000)}원",
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("합계 금액"),
                        Text("${priceToString.format(40000)}원"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: size.width * 0.46,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: color2,
                    side: const BorderSide(
                      color: color2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "변경된 이름 저장",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: size.width * 0.46,
                height: 60,
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
                    "변경된 이름 저장",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: size.width,
            height: 60,
            margin: const EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: color2,
                side: const BorderSide(
                  color: color2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "영수증 적용하기",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: false,
      ),
    );
  }
}
