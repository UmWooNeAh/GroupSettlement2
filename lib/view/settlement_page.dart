import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/design_element.dart';
import 'dart:math' as math;

import 'shared_basic_widget.dart';

class Informations {
  List<String> receipts = [
    "영수증1",
    "영수증2",
    "영수증3",
  ];
  List<double> receiptSize = [130, 130, 130];
  List<String> members = [
    "그룹원1",
    "그룹원2",
    "그룹원3",
    "그룹원4",
    "그룹원5",
    "그룹원6",
    "그룹원7",
    "그룹원8",
    "그룹원9",
    "그룹원10",
    "그룹원11",
    "그룹원12",
    "그룹원13",
    "그룹원14",
    "그룹원15",
    "그룹원16",
    "그룹원17",
    "그룹원18",
    "그룹원19",
  ];
  List<bool> receiptSelected = [false, false, false];
  Informations();
}

class Receiptss extends ChangeNotifier {
  Informations information = Informations();

  void selectedReceipt(index) {
    information.receiptSize[index] = 260;
    notifyListeners();
  }

  void disableReceipt(index) {
    information.receiptSize[index] = 130;
    notifyListeners();
  }

  void ableReceiptSelected(index) {
    information.receiptSelected[index] = true;
    notifyListeners();
  }

  void disableReceiptSelected(index) {
    information.receiptSelected[index] = false;
    notifyListeners();
  }
}

class BottomSheetValue {
  double currentHeight = 600;
  double previousHeight = 0;
  double closedHeight = 600;
  double openedHeight = 200;
  bool isOpen = false;
  BottomSheetValue();
}

class BottomSheetSlider extends ChangeNotifier {
  BottomSheetValue bottomsheet = BottomSheetValue();

  void setBottomSheetSlider(initial, closed, opened) {
    bottomsheet.currentHeight = initial;
    bottomsheet.closedHeight = closed;
    bottomsheet.openedHeight = opened;
  }

  void updateHeight(double updateHeight) {
    bottomsheet.previousHeight = bottomsheet.currentHeight;

    if (bottomsheet.currentHeight + updateHeight <= bottomsheet.openedHeight &&
        bottomsheet.currentHeight + updateHeight >= bottomsheet.closedHeight) {
      bottomsheet.currentHeight += updateHeight;
    }
    notifyListeners();
  }

  void updateOpenState() {
    if (!bottomsheet.isOpen) {
      if (bottomsheet.currentHeight - bottomsheet.previousHeight > 1.5 ||
          bottomsheet.currentHeight - bottomsheet.closedHeight > 50) {
        bottomsheet.isOpen = true;
        bottomsheet.currentHeight = bottomsheet.openedHeight;
      } else {
        bottomsheet.currentHeight = bottomsheet.closedHeight;
      }
    } else {
      if (bottomsheet.currentHeight - bottomsheet.previousHeight < -1.5 ||
          bottomsheet.currentHeight - bottomsheet.openedHeight < -50) {
        bottomsheet.isOpen = false;
        bottomsheet.currentHeight = bottomsheet.closedHeight;
      } else {
        bottomsheet.currentHeight = bottomsheet.openedHeight;
      }
    }
    notifyListeners();
  }
}

class SlidableAdder extends StateNotifier<double> {
  SlidableAdder() : super(5);

  void updateState(delta) {
    if (state - delta < 120 && state - delta > 5) {
      state -= delta;
    }
  }

  void settingEnd() {
    state = 120;
  }

  void settingInit() {
    state = 5;
  }
}

class ReadMore extends StateNotifier<double> {
  ReadMore() : super(1000);

  void clickReadMore() {
    state = 0;
  }

  void leaveReadMore() {
    state = 2000;
  }
}

final readMoreStateNotifierProvider =
    StateNotifierProvider((ref) => ReadMore());

final receiptssChangeNotifierProvider =
    ChangeNotifierProvider((ref) => Receiptss());

class SettlementPage extends ConsumerStatefulWidget {
  const SettlementPage({super.key});

  @override
  ConsumerState<SettlementPage> createState() => _SettlementPageState();
}

final bottomSheetSliderChangeNotifierProviedr =
    ChangeNotifierProvider<BottomSheetSlider>((ref) => BottomSheetSlider());

class _SettlementPageState extends ConsumerState<SettlementPage> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bottomsheetValue =
        ref.watch(bottomSheetSliderChangeNotifierProviedr.notifier);
    if (i == 0) {
      bottomsheetValue.setBottomSheetSlider(0.0, 0.0, size.height * 0.7);
      i++;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SettlementInteractiveViewer(size: size),
          SlidableAdderWidget(size: size),
          GroupUserBar(size: size),
          Positioned(
            right: 0,
            bottom: ref.watch(readMoreStateNotifierProvider) as double,
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .watch(readMoreStateNotifierProvider.notifier)
                          .leaveReadMore();
                    },
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 100,
                  child: DragTarget(onLeave: (data) {
                    ref
                        .watch(readMoreStateNotifierProvider.notifier)
                        .leaveReadMore();
                  }, builder: (context, cadidateData, rejectedData) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height:
                          ref.watch(readMoreStateNotifierProvider) as double ==
                                  0
                              ? 300
                              : 10,
                      width:
                          ref.watch(readMoreStateNotifierProvider) as double ==
                                  0
                              ? 300
                              : 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF0F0F0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: 300,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 5),
                              child: const Text(
                                "그룹원 목록",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              children: List.generate(
                                ref
                                            .watch(
                                                receiptssChangeNotifierProvider
                                                    .notifier)
                                            .information
                                            .members
                                            .length ~/
                                        4 +
                                    1,
                                (index) {
                                  return Row(
                                    children: List.generate(
                                        math.min(
                                            4,
                                            -(4 * index) +
                                                ref
                                                    .watch(
                                                        receiptssChangeNotifierProvider
                                                            .notifier)
                                                    .information
                                                    .members
                                                    .length), (iindex) {
                                      return SettlementPageGroupUser(
                                        index: index * 4 + iindex,
                                        ovalSize: 45,
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProviedr.notifier)
                        .updateHeight(-details.delta.dy);
                    setState(() {});
                  },
                  onVerticalDragEnd: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProviedr.notifier)
                        .updateOpenState();
                    setState(() {});
                  },
                  child: Container(
                    height: 60,
                    width: size.width,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Colors.black45,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                            top: 20,
                            left: 20,
                            child: Text(
                              "예상 최종 정산서",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Align(
                          alignment: Alignment.topCenter,
                          child: bottomsheetValue.bottomsheet.isOpen
                              ? const Icon(Icons.keyboard_arrow_down_outlined)
                              : const Icon(Icons.keyboard_arrow_up_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProviedr.notifier)
                        .updateHeight(-details.delta.dy);

                    setState(() {});
                  },
                  onVerticalDragEnd: (details) {
                    ref
                        .watch(bottomSheetSliderChangeNotifierProviedr.notifier)
                        .updateOpenState();
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: (bottomsheetValue.bottomsheet.currentHeight -
                                    bottomsheetValue.bottomsheet.previousHeight)
                                .abs() >
                            3
                        ? const Duration(milliseconds: 300)
                        : const Duration(),
                    curve: Curves.decelerate,
                    height: bottomsheetValue.bottomsheet.currentHeight,
                    width: size.width,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 2,
                                width: size.width,
                                color: Colors.grey[300],
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.grey[200],
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: size.width,
                                      child: const Text(
                                        "정산서 목록",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(10, (index) {
                                            if (index < 1) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 15, 15, 0),
                                                child: Column(
                                                  children: [
                                                    ClipOval(
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        color: color1,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Text("전체 정산서"),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: ClipOval(
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text("이름"),
                                                ],
                                              );
                                            }
                                          }),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                height: 2,
                                width: size.width,
                                color: Colors.grey[300],
                              ),
                              Container(
                                width: size.width,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: const Text(
                                  "전체 정산서",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 300,
                                  width: size.width,
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(10, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text("류지원"),
                                              Text("짜장면 등 $index 메뉴"),
                                              Text(
                                                  "${priceToString.format(10000)}원",
                                                  style: const TextStyle(
                                                    color: color2,
                                                  ))
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  )),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: const Row(
                                  children: [
                                    Text("합계금액"),
                                    Text(" 40,000원"),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  context.go(
                                      "/SettlementPage/SettlementFinalCheckPage");
                                },
                                child: const Text("정산 완료하기"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 100,
            top: 100,
            child: Visibility(
              visible: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: size.width - 110,
                height: size.height * 0.5,
                color: Colors.pink[100],
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(10, (index) {
                      return DragTarget(
                        builder: (context, candidateData, rejectedData) {
                          return const SettlementPageReceiptItem();
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: "a"),
          BottomNavigationBarItem(icon: Icon(Icons.abc_outlined), label: "b"),
          BottomNavigationBarItem(icon: Icon(Icons.abc_rounded), label: "c"),
        ],
      ),
    );
  }
}

class SettlementInteractiveViewer extends ConsumerStatefulWidget {
  const SettlementInteractiveViewer({super.key, required this.size});
  final Size size;

  @override
  ConsumerState<SettlementInteractiveViewer> createState() =>
      _SettlementInteractiveViewerState();
}

class _SettlementInteractiveViewerState
    extends ConsumerState<SettlementInteractiveViewer> {
  late Size size;
  @override
  void initState() {
    super.initState();
    size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.25,
      maxScale: 20.0,
      boundaryMargin: const EdgeInsets.all(5),
      child: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: List.generate(
                150,
                (index) {
                  int row = 30;
                  if (index < row) {
                    return Positioned(
                      top: 30 * index + 5,
                      child: Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey[300],
                      ),
                    );
                  } else {
                    return Positioned(
                      left: 30 * (index - row) + 5,
                      child: Container(
                        height: size.height,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: List.generate(
                  ref
                      .watch(receiptssChangeNotifierProvider.notifier)
                      .information
                      .receipts
                      .length, (index) {
                return SettlementPageReceipt(index: index);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupUserBar extends ConsumerStatefulWidget {
  const GroupUserBar({super.key, required this.size});
  final Size size;

  @override
  ConsumerState<GroupUserBar> createState() => _GroupUserBarState();
}

class _GroupUserBarState extends ConsumerState<GroupUserBar> {
  late Size size;
  @override
  void initState() {
    super.initState();
    size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      child: Container(
        color: Colors.grey[200],
        width: size.width,
        height: 160,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text(
                    "그룹원",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      ref
                          .watch(readMoreStateNotifierProvider.notifier)
                          .clickReadMore();
                    },
                    child: const Text(
                      "자세히보기 >",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  ref
                      .watch(receiptssChangeNotifierProvider.notifier)
                      .information
                      .members
                      .length,
                  (index) {
                    return SettlementPageGroupUser(
                      index: index,
                      ovalSize: 50,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlidableAdderWidget extends ConsumerStatefulWidget {
  const SlidableAdderWidget({super.key, required this.size});
  final Size size;

  @override
  ConsumerState<SlidableAdderWidget> createState() =>
      _SlidableAdderWidgetState();
}

class _SlidableAdderWidgetState extends ConsumerState<SlidableAdderWidget> {
  final slidableAdderStateNotifierProvider =
      StateNotifierProvider((ref) => SlidableAdder());
  late Size size;
  @override
  void initState() {
    super.initState();
    size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height / 3,
      right: ref.watch(slidableAdderStateNotifierProvider) as double,
      child: ClipOval(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.grey,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              ref
                  .watch(slidableAdderStateNotifierProvider.notifier)
                  .updateState(details.delta.dx);
            },
            onHorizontalDragEnd: (details) {
              if ((ref.watch(slidableAdderStateNotifierProvider) as double) >
                  80) {
                ref
                    .watch(slidableAdderStateNotifierProvider.notifier)
                    .settingEnd();
              } else {
                ref
                    .watch(slidableAdderStateNotifierProvider.notifier)
                    .settingInit();
              }
            },
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // 투시 변환 적용 (원근감 제거)
                ..rotateZ(-math.pi /
                    40 *
                    ((ref.watch(slidableAdderStateNotifierProvider) as double) -
                        5)),
              alignment: Alignment.center,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}

class SettlementPageReceiptItem extends StatefulWidget {
  const SettlementPageReceiptItem({super.key});

  @override
  State<SettlementPageReceiptItem> createState() =>
      _SettlementPageReceiptItemState();
}

class _SettlementPageReceiptItemState extends State<SettlementPageReceiptItem> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: selected ? 150 : 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber,
            ),
            child: selected
                ? const Column(
                    children: [
                      Row(
                        children: [
                          Text("짜장면"),
                          Text("6000원"),
                        ],
                      ),
                    ],
                  )
                : const Column(
                    children: [
                      Row(
                        children: [
                          Text("짜장면"),
                          Text("6000원"),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class SettlementPageReceipt extends ConsumerWidget {
  const SettlementPageReceipt({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 10,
      left: index * 120 + 10,
      child: GestureDetector(
        onTapDown: (details) {
          ref
              .watch(receiptssChangeNotifierProvider.notifier)
              .ableReceiptSelected(index);
        },
        onTapUp: (details) {
          ref
              .watch(receiptssChangeNotifierProvider.notifier)
              .disableReceiptSelected(index);
        },
        onTapCancel: () {
          ref
              .watch(receiptssChangeNotifierProvider.notifier)
              .disableReceiptSelected(index);
        },
        onTap: () {},
        child: DragTarget(
          onWillAccept: (data) {
            ref
                .watch(receiptssChangeNotifierProvider.notifier)
                .ableReceiptSelected(index);
            return true;
          },
          onLeave: (data) {
            ref
                .watch(receiptssChangeNotifierProvider.notifier)
                .disableReceiptSelected(index);
          },
          onAccept: (data) {
            ref
                .watch(receiptssChangeNotifierProvider.notifier)
                .disableReceiptSelected(index);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 100,
              height: ref
                  .watch(receiptssChangeNotifierProvider.notifier)
                  .information
                  .receiptSize[index],
              decoration: BoxDecoration(
                color: (ref
                        .watch(receiptssChangeNotifierProvider)
                        .information
                        .receiptSelected[index])
                    ? Colors.black26
                    : Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Text(ref
                      .watch(receiptssChangeNotifierProvider.notifier)
                      .information
                      .receipts[index]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettlementPageGroupUser extends ConsumerWidget {
  const SettlementPageGroupUser(
      {super.key, required this.index, required this.ovalSize});
  final double ovalSize;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: LongPressDraggable(
        delay: const Duration(
          milliseconds: 300,
        ),
        data: 1,
        childWhenDragging: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: SizedBox(
                height: ovalSize,
                width: ovalSize,
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(ref
                  .watch(receiptssChangeNotifierProvider.notifier)
                  .information
                  .members[index]),
            ),
          ],
        ),
        feedback: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 15, 5),
          child: Container(
            height: ovalSize * 1.2,
            width: ovalSize * 1.2,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Container(
                height: ovalSize,
                width: ovalSize,
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(ref
                  .watch(receiptssChangeNotifierProvider.notifier)
                  .information
                  .members[index]),
            ),
          ],
        ),
      ),
    );
  }
}
