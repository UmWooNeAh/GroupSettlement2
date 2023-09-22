import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/design_element.dart';
import 'dart:math' as math;
import 'package:groupsettlement2/view/gun_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
// import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
// import 'package:bottom_sheet/bottom_sheet.dart';

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

class _SettlementPageState extends ConsumerState<SettlementPage> {
  final slidableAdderStateNotifierProvider =
      StateNotifierProvider((ref) => SlidableAdder());

  @override
  void initState() {
    super.initState();
    ref.read(receiptssChangeNotifierProvider);
    ref.read(changeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BottomSheetScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.25,
            maxScale: 10.0,
            boundaryMargin: const EdgeInsets.all(5),
            child: Stack(
              children: List.generate(
                ref
                        .watch(receiptssChangeNotifierProvider.notifier)
                        .information
                        .receipts
                        .length +
                    30,
                (index) {
                  if (index < 15) {
                    return Positioned(
                      top: (size.height / 15) * index + 5,
                      child: Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey[300],
                      ),
                    );
                  } else if (index < 30) {
                    return Positioned(
                      left: (size.height / 15) * (index - 15) + 5,
                      child: Container(
                        height: size.height,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                    );
                  } else {
                    return SettlementPageReceipt(index: index - 30);
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: size.height / 3,
            right: ref.watch(slidableAdderStateNotifierProvider) as double,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorGrey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  ref
                      .watch(slidableAdderStateNotifierProvider.notifier)
                      .updateState(details.delta.dx);
                },
                onHorizontalDragEnd: (details) {
                  if ((ref.watch(slidableAdderStateNotifierProvider)
                          as double) >
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
                        ((ref.watch(slidableAdderStateNotifierProvider)
                                as double) -
                            5)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.grey[200],
              width: size.width,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20, child: Text("그룹원")),
                      TextButton(
                          onPressed: () {
                            ref
                                .watch(readMoreStateNotifierProvider.notifier)
                                .clickReadMore();
                          },
                          child: const Text("자세히보기")),
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
                                .length, (index) {
                      return SettlementPageGroupUser(index: index);
                    })),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: ref.watch(readMoreStateNotifierProvider) as double,
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black12,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .watch(readMoreStateNotifierProvider.notifier)
                          .leaveReadMore();
                    },
                  ),
                ),
                Positioned(
                  left: 100,
                  top: 200,
                  child: DragTarget(onLeave: (data) {
                    ref
                        .watch(readMoreStateNotifierProvider.notifier)
                        .leaveReadMore();
                  }, builder: (context, cadidateData, rejectedData) {
                    return Container(
                      height: 300,
                      width: 250,
                      color: Colors.amber,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              ref
                                          .watch(receiptssChangeNotifierProvider
                                              .notifier)
                                          .information
                                          .members
                                          .length ~/
                                      3 +
                                  1, (index) {
                            return Row(
                              children: List.generate(
                                  math.min(
                                      3,
                                      -(3 * index) +
                                          ref
                                              .watch(
                                                  receiptssChangeNotifierProvider
                                                      .notifier)
                                              .information
                                              .members
                                              .length), (iindex) {
                                return SettlementPageGroupUser(
                                    index: index * 3 + iindex);
                              }),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: DraggableBottomSheet(
        gradientOpacity: false,
        animationDuration: const Duration(milliseconds: 200),
        headerVisibilityOnTap: true,
        radius: 20,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("에상 최종 정산서"),
            ),
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      const Text("정산서 목록"),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                10,
                                (index) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.black54),
                                          ),
                                        ),
                                        const Text("이름"),
                                      ],
                                    )),
                          )),
                    ],
                  ),
                ),
                const Text("전체 정산서"),
                Container(
                    height: 300,
                    width: size.width * 0.9,
                    color: Colors.pink[50],
                    child: Column(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("류지원"),
                              Text("짜장면 등 $index 메뉴"),
                              const Text("10000원",
                                  style: TextStyle(
                                    color: color2,
                                  ))
                            ],
                          ),
                        );
                      }),
                    ))
              ],
            ),
          ],
        ),
        header: Container(
          height: 60,
          width: size.width,
          color: colorGrey,
        ),
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

class SettlementPageReceipt extends ConsumerWidget {
  const SettlementPageReceipt({super.key, required this.index});
  final int index;
  WoltModalSheetPage page1(
      BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage.withSingleChild(
      hasSabGradient: false,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(modalSheetContext).pop(),
              child: const SizedBox(
                height: 50,
                width: double.infinity,
                child: Center(child: Text('Cancel')),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const SizedBox(
                height: 50,
                width: double.infinity,
                child: Center(child: Text('Next page')),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text('Pagination', style: textTheme.titleSmall),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(10),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
        child: Column(
          children: [
            Draggable(
                feedback: Container(
                  height: 40,
                  width: 40,
                  color: Colors.yellow,
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.blue,
                )),
            Container(
              width: 100,
              height: 100,
              color: Colors.amber,
            ),
            const Text(
              '''
      Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
      ''',
            ),
          ],
        ),
      ),
    );
  }

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
        onTap: () {
          WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              final textTheme = Theme.of(context).textTheme;
              return [
                page1(modalSheetContext, textTheme),
              ];
            },
            modalTypeBuilder: (context) {
              final size = MediaQuery.of(context).size.width;
              if (size < 100) {
                return WoltModalType.bottomSheet;
              } else {
                return WoltModalType.dialog;
              }
            },
            onModalDismissedWithBarrierTap: () {
              debugPrint('Closed modal sheet with barrier tap');
              Navigator.of(context).pop();
            },
            maxDialogWidth: 560,
            minDialogWidth: 400,
            minPageHeight: 0.7,
            maxPageHeight: 0.9,
          );
        },
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
            print("drag success!! =======================");
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
  const SettlementPageGroupUser({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: LongPressDraggable(
        data: 1,
        childWhenDragging: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: SizedBox(
                height: 50,
                width: 50,
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
            height: 60,
            width: 60,
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
                height: 50,
                width: 50,
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

class RotationTest extends StatefulWidget {
  const RotationTest({super.key});

  @override
  State<RotationTest> createState() => _RotationTestState();
}

class _RotationTestState extends State<RotationTest> {
  double angularValueX = 0;
  double angularValueY = 0;
  double angularValueZ = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(100, 100),
          // ref.watch(offsetChangeNotifierProvider.notifier).testOffset,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 투시 변환 적용 (원근감 제거)
              ..rotateX(angularValueX * math.pi / 4)
              ..rotateY(angularValueY * math.pi / 4),
            // ..rotateZ(angularValueZ * math.pi / 4),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          left: 100,
          top: 200,
          child: Draggable(
            onDragUpdate: (details) {
              // ref
              //     .watch(offsetChangeNotifierProvider.notifier)
              //     .updateOffset(details.delta);
              setState(() {
                angularValueX -= 0.01 * details.delta.dy;
                angularValueY -= 0.01 * details.delta.dx;
              });
            },
            feedback: Container(
              height: 50,
              width: 50,
              color: Colors.blueAccent,
            ),
            childWhenDragging: const SizedBox(
              height: 50,
              width: 50,
            ),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
