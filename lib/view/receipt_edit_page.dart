import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import '../class/class_receiptContent.dart';
import '../class/class_receiptitem.dart';
import '../viewmodel/SettlementCreateViewModel.dart';

class EditReceiptPage extends ConsumerStatefulWidget {
  final ReceiptContent receiptContent;
  final String modifyFlag;
  const EditReceiptPage(
      {super.key, required this.receiptContent, required this.modifyFlag});

  @override
  ConsumerState<EditReceiptPage> createState() => _EditReceiptState();
}

class _EditReceiptState extends ConsumerState<EditReceiptPage> {
  List<TextEditingController> menuController = [];
  List<TextEditingController> countController = [];
  List<TextEditingController> priceController = [];
  late bool modifyFlag;
  @override
  void initState() {
    super.initState();
    modifyFlag = widget.modifyFlag == "false" ? false : true;
    for (int i = 0; i < widget.receiptContent.receiptItems.length; i++) {
      ReceiptItem receiptItem = widget.receiptContent.receiptItems[i];
      menuController.add(TextEditingController(text: receiptItem.menuName));
      countController
          .add(TextEditingController(text: receiptItem.menuCount.toString()));
      priceController.add(TextEditingController(
          text: priceToString.format(receiptItem.menuPrice ?? 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final stmvm = ref.watch(stmCreateProvider);
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
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
                        child: Text(
                            "업체명: ${widget.receiptContent.receipt!.storeName}")),
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
                            widget.receiptContent.receiptItems.length,
                            (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: TextField(
                                        controller: menuController[index],
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
                                          controller: countController[index],
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
                                          controller: priceController[index],
                                          showCursor: true,
                                          maxLength: 13,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == '') {
                                                priceController[index].text =
                                                    '0';
                                              } else {
                                                priceController[index].text =
                                                    priceToString.format(
                                                        priceToString
                                                            .parse(value));
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
                            "${priceToString.format(priceController.map((price) => priceToString.parse(price.text)).reduce((value, element) => value + element))}원",
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
                onPressed: () {
                  widget.receiptContent.receipt!.totalPrice = priceController
                      .map((price) => priceToString.parse(price.text))
                      .reduce((value, element) => value + element)
                      .toInt();
                  for (var index in Iterable.generate(
                      widget.receiptContent.receiptItems.length)) {
                    widget.receiptContent.receiptItems[index].menuName =
                        menuController[index].text;
                    try {
                      widget.receiptContent.receiptItems[index].menuCount =
                          int.parse(countController[index].text);
                      if (widget.receiptContent.receiptItems[index].menuCount! <
                          1) {
                        return;
                      }
                    } catch (e) {
                      print(
                          "$index번 인덱스 수량에 숫자가 아닌 값이 들어감\n ${menuController[index].text} , ${countController[index].text} , ${priceController[index].text}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${index + 1}번째 항목의 수량이 잘못되었어요. : ${countController[index].text}'),
                        duration: const Duration(seconds: 3),
                      ));
                      return;
                    }
                    try {
                      widget.receiptContent.receiptItems[index].menuPrice =
                          priceToString
                              .parse(priceController[index].text)
                              .toInt();
                    } catch (e) {
                      print(
                          "$index번 인덱스 가격에 숫자가 아닌 값이 들어감\n ${menuController[index].text} , ${countController[index].text} , ${priceController[index].text}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${index + 1}번째 항목의 가격이 잘못되었어요. : ${priceController[index].text}'),
                        duration: const Duration(seconds: 3),
                      ));
                      return;
                    }
                  }
                  if (modifyFlag == true) {
                    stmvm.receipts[widget.modifyFlag] =
                        widget.receiptContent.receipt!;
                    stmvm.receiptItems[widget.modifyFlag] =
                        widget.receiptContent.receiptItems;
                    stmvm.notifyListeners();
                    context.go("/CreateNewSettlementPage/null/null/null");
                  } else {
                    context.go("/scanedRecieptPage",
                        extra: widget.receiptContent);
                  }
                },
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
      ),
    );
  }
}
