import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class SettlementFinalCheckPage extends ConsumerStatefulWidget {
  const SettlementFinalCheckPage({super.key});

  @override
  ConsumerState<SettlementFinalCheckPage> createState() =>
      _SettlementFinalCheckPage();
}

class _SettlementFinalCheckPage
    extends ConsumerState<SettlementFinalCheckPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            width: size.width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text(
              "정산 1",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            width: size.width,
            child: const Text(
              "정산 결과 확인",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: List.generate(10, (index) {
                return SettlementFinalCheckUserPanel(index: index);
              }),
            ),
          )),
          const Divider(
            thickness: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "합계 금액",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${priceToString.format(40000)}원",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: color2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
              child: const Text(
                "전체 정산서 확인하기",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: 80,
            width: size.width,
            color: Colors.grey[100],
            child: Align(
              alignment: const Alignment(0, 0),
              child: Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                  child: const Text(
                    "홈으로 이동하기",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettlementFinalCheckUserPanel extends StatefulWidget {
  const SettlementFinalCheckUserPanel({super.key, required this.index});
  final int index;

  @override
  State<SettlementFinalCheckUserPanel> createState() =>
      _SettlementFinalCheckUserPanelState();
}

class _SettlementFinalCheckUserPanelState
    extends State<SettlementFinalCheckUserPanel> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            width: size.width,
            color: Colors.transparent,
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
                          padding: const EdgeInsets.all(10.0),
                          width: 60,
                          height: 60,
                          color: colorGrey,
                        ),
                      ),
                      Text(
                        "이름 ${widget.index}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "${priceToString.format(widget.index * 10000)}원",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          endIndent: 10,
          indent: 10,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width,
          height: selected ? 70 : 0,
          color: Colors.grey[200],
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {},
              child: Stack(
                children: [
                  Visibility(
                    visible: selected ? true : false,
                    child: const Align(
                      alignment: Alignment(1, 0.0),
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0, 0),
                    child: Text(
                      "정산서 확인",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
