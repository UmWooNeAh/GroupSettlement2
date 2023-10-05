import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "수정하고자 하는 ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "항목",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: color1,
                  ),
                ),
                TextSpan(
                  text: "을 ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "터치",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: color1,
                  ),
                ),
                TextSpan(
                  text: "하여 수정하세요.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                  Container(
                    margin: const EdgeInsets.all(
                      10,
                    ),
                    child: const Text(
                      "영수증 1",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 20,
                      ),
                      width: size.width,
                      child: const Text(
                          "거래일시 : ${2023}.${7}.${27} ${"19:58:23"}")),
                  Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 20,
                      ),
                      width: size.width,
                      child: const Text("업체명: 달빛한모금 경북대점")),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    height: 30,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            "메뉴",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: Text(
                              "수량",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: color2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment(1, 0),
                            child: Text(
                              "가격",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: color2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          10,
                          (index) {
                            return EditReceiptDataRow(index: index);
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 4,
                    color: Colors.grey[200],
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      40,
                      10,
                      40,
                      20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "합계 금액",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${priceToString.format(40000)}원",
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: color2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: size.width,
            height: 60,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "항목 추가하기",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
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
                "수정 완료",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditReceiptDataRow extends StatefulWidget {
  const EditReceiptDataRow({super.key, required this.index});
  final int index;

  @override
  State<EditReceiptDataRow> createState() => _EditReceiptDataRowState();
}

class _EditReceiptDataRowState extends State<EditReceiptDataRow> {
  late final int index;
  final TextEditingController _menuController =
      TextEditingController(text: "짜장면");
  final TextEditingController _countController =
      TextEditingController(text: "0");
  late final TextEditingController _priceController;
  @override
  void initState() {
    super.initState();
    index = widget.index;
    _priceController =
        TextEditingController(text: priceToString.format(widget.index * 10000));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140,
            child: TextField(
              controller: _menuController,
              showCursor: true,
              maxLength: 13,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Align(
              alignment: const Alignment(1, 0),
              child: TextField(
                textAlign: TextAlign.end,
                controller: _countController,
                showCursor: true,
                maxLength: 13,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Align(
              alignment: const Alignment(1, 0),
              child: TextField(
                textAlign: TextAlign.end,
                controller: _priceController,
                showCursor: true,
                maxLength: 13,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value == '') {
                      _priceController.text = '0';
                    } else {
                      _priceController.text =
                          priceToString.format(priceToString.parse(value));
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
