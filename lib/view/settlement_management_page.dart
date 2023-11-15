import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class TotalSettlementDetailsManagement extends ConsumerStatefulWidget {
  const TotalSettlementDetailsManagement({super.key});

  @override
  ConsumerState<TotalSettlementDetailsManagement> createState() =>
      _TotalSettlementDetailsManagement();
}

class _TotalSettlementDetailsManagement
    extends ConsumerState<TotalSettlementDetailsManagement> {
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
              "정산 현황",
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
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: false,
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
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "정산완료",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: color2,
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
          height: selected ? 80 : 0,
          color: Colors.grey[200],
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    width: size.width,
                    height: size.height,
                    margin: const EdgeInsets.only(right: 5),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: color1,
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {},
                      child: const Text(
                        "정산 확인 취소",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
