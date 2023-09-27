import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';

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
          const Text("정산 1"),
          const Text("정산 결과 확인"),
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
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("합계 금액"),
                Text("40000"),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 40,
            margin: const EdgeInsets.all(10),
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
                "전체 정산서 확인",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            width: size.width,
            height: 40,
            margin: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.amber[300],
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
              child: const Text(
                "카카오톡으로 정산서 공유하기",
                style: TextStyle(color: Colors.black),
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
                      Text("이름 ${widget.index}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("${widget.index * 10000}원"),
                )
              ],
            ),
          ),
        ),
        const Divider(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width,
          height: selected ? 80 : 0,
          color: colorGrey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              onPressed: () {},
              child: const Text(
                "정산서 확인",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }
}
