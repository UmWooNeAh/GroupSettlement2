import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class CreateNewSettlement extends ConsumerStatefulWidget {
  const CreateNewSettlement({super.key});

  @override
  ConsumerState<CreateNewSettlement> createState() =>
      _CreateNewSettlementState();
}

class _CreateNewSettlementState extends ConsumerState<CreateNewSettlement> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: const Text(
                "UWNA",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Text(
                "새 정산 생성하기",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            Container(
                width: size.width,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: const Text(
                  "정산 이름을 입력해주세요.",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                width: size.width * 0.8,
                child: const TextField()),
            Container(
              height: 2,
              color: Colors.grey[300],
            ),
            Container(
              height: 300,
              width: size.width,
              color: Colors.grey[200],
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "영수증",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "합계 78000원",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(10, (index) {
                      return CreateNewSettlementReceipt(index: index);
                    }),
                  ),
                )
              ]),
            ),
            Container(
              width: size.width,
              height: 2,
              color: Colors.grey[300],
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FloatingActionButton(
                      elevation: 2,
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xFFFFFFFF),
                      onPressed: () {
                        context.push("/SettlementDetailPageSender");
                      },
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'images/receipt_box.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "새 영수증 추가",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: size.width,
              height: 5,
              color: Colors.grey[200],
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/SettlementPage');
                },
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
                  "정산 생성하기",
                  style: TextStyle(fontSize: 20, color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 2,
        isIn: true,
      ),
    );
  }
}

class CreateNewSettlementReceipt extends ConsumerStatefulWidget {
  const CreateNewSettlementReceipt({super.key, required this.index});
  final int index;

  @override
  ConsumerState<CreateNewSettlementReceipt> createState() =>
      _CreateNewSettlementReceiptState();
}

class _CreateNewSettlementReceiptState
    extends ConsumerState<CreateNewSettlementReceipt> {
  bool isTapDown = false;
  @override
  Widget build(BuildContext context) {
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
        context.push('/CreateNewSettlementPage/EditReceiptPage');
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
            color:
                isTapDown ? const Color(0xFFCCCCCC) : const Color(0xFFF4F4F4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ]),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
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
                "영수증 ${widget.index}",
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Positioned(
                top: 80,
                left: 10,
                child: RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: "${widget.index}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: " 등 ${widget.index} 항목",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        )
                      ]),
                )),
            const Positioned(
                bottom: 50,
                right: 10,
                child: Text(
                  "합계 금액",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )),
            const Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                "46,000원",
                style: TextStyle(
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
