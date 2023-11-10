import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/class/class_receipt.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';
import 'package:groupsettlement2/viewmodel/UserViewModel.dart';

class ReceiptBoxPage extends ConsumerStatefulWidget {
  const ReceiptBoxPage({super.key});

  @override
  ConsumerState<ReceiptBoxPage> createState() => _ReceiptBoxPageState();
}

class _ReceiptBoxPageState extends ConsumerState<ReceiptBoxPage> {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(userProvider);
    if (isFirst) {
      provider.settingUserViewModel("8969xxwf-8wf8-pf89-9x6p-88p0wpp9ppfb");
      isFirst = false;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: const Text(
              "내 영수증 박스",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    (provider.myReceipts.length + 1) ~/ (size.width ~/ 180) + 1,
                    (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      size.width ~/ 180,
                      (iindex) {
                        if (provider.myReceipts.length == 14) {
                          if (index * (size.width ~/ 180) + iindex >
                              provider.myReceipts.length - 1) {
                            if (provider.myReceipts.length %
                                    (size.width ~/ 180) ==
                                0) {
                              return const SizedBox();
                            }
                            return Container(
                              height: (provider.myReceipts.length) ~/ (size.width ~/ 180) < index ? 0 : 200,
                              width: 150,
                              margin: const EdgeInsets.all(10),
                              color: Colors.green,
                            );
                          }
                          return StoredReceipt(
                              index: index * (size.width ~/ 180) + iindex + 1);
                        }
                        if (index * (size.width ~/ 180) + iindex >
                            provider.myReceipts.length) {
                          return Container(
                            height: (provider.myReceipts.length + 1) % (size.width ~/ 180) == 0 ? 0 : 200,
                            width: 150,
                            margin: const EdgeInsets.all(10),
                            color: Colors.green,
                          );
                        }
                        if (index + iindex == 0) {
                          return const AddingReceipt();
                        }
                        return StoredReceipt(
                            index: index * (size.width ~/ 180) + iindex);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const CustomBottomNavigationBar(index: 0, isIn: false),
    );
  }
}

class StoredReceipt extends ConsumerStatefulWidget {
  const StoredReceipt({super.key, required this.index});
  final int index;

  @override
  ConsumerState<StoredReceipt> createState() => _StoredReceiptState();
}

class _StoredReceiptState extends ConsumerState<StoredReceipt> {
  bool isTapDown = false;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(userProvider);
    int index = widget.index - 1;
    Receipt? receipt = provider.myReceipts[index];
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isTapDown = !isTapDown;
        });
      },
      onTapUp: (details) {
        setState(() {
          isTapDown = !isTapDown;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapDown = !isTapDown;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          color: isTapDown ? const Color(0xFFECECEC) : const Color(0xFFFCFCFC),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  provider.deleteSavedReceipt(receipt.receiptId!);
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: color1,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Text(
                receipt.receiptName ?? "영수증",
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 10,
              child: Container(
                width: 150,
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: provider.firstReceiptItemName[receipt.receiptId]
                                ?.substring(
                                    0,
                                    min(
                                        10,
                                        provider
                                                .firstReceiptItemName[
                                                    receipt.receiptId]
                                                ?.length ??
                                            0)) ??
                            "menu",
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: " 등 ${receipt.receiptItems.length} 항목",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
                bottom: 50,
                right: 10,
                child: Text(
                  "합계 금액",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                priceToString.format(receipt.totalPrice),
                style: const TextStyle(
                  color: color1,
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddingReceipt extends ConsumerStatefulWidget {
  const AddingReceipt({super.key});

  @override
  ConsumerState<AddingReceipt> createState() => _AddingReceiptState();
}

class _AddingReceiptState extends ConsumerState<AddingReceipt> {
  bool isTapDown = false;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(userProvider);
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isTapDown = !isTapDown;
        });
      },
      onTapUp: (details) {
        setState(() {
          isTapDown = !isTapDown;
          provider.createSavedReceipt();
        });
      },
      onTapCancel: () {
        setState(() {
          isTapDown = !isTapDown;
        });
      },
      child: DottedBorder(
        padding: const EdgeInsets.all(0),
        strokeWidth: 2,
        dashPattern: const [15, 15],
        strokeCap: StrokeCap.butt,
        customPath: (size) => Path()
          ..moveTo(10, 10)
          ..lineTo(10, 210)
          ..lineTo(160, 210)
          ..lineTo(160, 10)
          ..lineTo(10, 10),
        child: Container(
          height: 200,
          width: 150,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                isTapDown ? const Color(0xFFCCCCCC) : const Color(0xFFF4F4F4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  dashPattern: const [6, 6],
                  child: const ClipOval(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "새 영수증 추가",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
