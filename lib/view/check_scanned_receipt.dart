import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/class/class_receiptitem.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/SettlementCreateViewModel.dart';

import '../class/class_receiptContent.dart';

class CheckScannedReceiptPge extends ConsumerStatefulWidget {
  final ReceiptContent receiptContent;
  const CheckScannedReceiptPge({super.key,required this.receiptContent});

  @override
  ConsumerState<CheckScannedReceiptPge> createState() =>
      _CheckScannedReceiptPge();
}

class _CheckScannedReceiptPge extends ConsumerState<CheckScannedReceiptPge> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final stmvm = ref.watch(stmCreateProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "스캔된 영수증 ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: color1,
                  ),
                ),
                TextSpan(
                  text: "내용이 맞는지 ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "확인",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: color1,
                  ),
                ),
                TextSpan(
                  text: "해 주세요.",
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
                      child: Text("업체명: ${widget.receiptContent.receipt!.storeName}")),
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
                            ReceiptItem receiptItem = widget.receiptContent.receiptItems[index];
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
                                      child: Text(
                                        receiptItem.menuName ?? "null",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 40,
                                    child: Align(
                                      alignment: const Alignment(1, 0),
                                      child: Text(
                                        receiptItem.menuCount != null ? receiptItem.menuCount.toString() : "null",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Align(
                                      alignment: const Alignment(1, 0),
                                      child: Text(
                                        receiptItem.menuPrice != null ?
                                        "${priceToString.format(receiptItem.menuPrice)}원" : "null",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                          "${priceToString.format(widget.receiptContent.receipt!.totalPrice)}원",
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
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "다시 촬영하기",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
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
                    backgroundColor: Colors.grey[300],
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: GestureDetector(
                    onTap:(){
                      context.push('/CreateNewSettlementPage/editReceiptPage',extra: widget.receiptContent);
                    },
                    child: const Text(
                      "직접 수정하기",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
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
              onPressed: () {
                stmvm.addReceipt(widget.receiptContent);
                context.go('/CreateNewSettlementPage');
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
                "영수증 적용하기",
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
