import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/class/class_receipt.dart';
import 'package:groupsettlement2/design_element.dart';
import 'dart:math' as math;
import 'shared_basic_widget.dart';
import '../viewmodel/SettlementViewModel.dart';

class CheckSettlementPaper extends ChangeNotifier {
  String selectedUserId = "default";
  String selectedUserName = "전체 정산서";

  void selectUser(userId, userName) {
    selectedUserId = userId;
    selectedUserName = userName;
    notifyListeners();
  }

  void setting() {
    selectedUserId = "default";
    selectedUserName = "전체 정산서";
  }
}

class BottomSheetSlider extends ChangeNotifier {
  double currentHeight = 600;
  double previousHeight = 0;
  double closedHeight = 600;
  double openedHeight = 200;
  bool isOpen = false;

  void setBottomSheetSlider(initial, closed, opened) {
    currentHeight = initial;
    closedHeight = closed;
    openedHeight = opened;
  }

  void updateHeight(double updateHeight) {
    previousHeight = currentHeight;
    if (currentHeight + updateHeight <= openedHeight &&
        currentHeight + updateHeight >= closedHeight) {
      currentHeight += updateHeight;
    }
    notifyListeners();
  }

  void updateOpenState() {
    if (!isOpen) {
      if (currentHeight - previousHeight > 1.5 ||
          currentHeight - closedHeight > 50) {
        isOpen = true;
        currentHeight = openedHeight;
      } else {
        currentHeight = closedHeight;
      }
    } else {
      if (currentHeight - previousHeight < -1.5 ||
          currentHeight - openedHeight < -50) {
        isOpen = false;
        currentHeight = closedHeight;
      } else {
        currentHeight = openedHeight;
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

class IsReceiptOpened extends ChangeNotifier {
  bool isOpened = false;
  String receiptId = "default";
  int count = 1;
  List<Offset> receiptPosition =
      List.generate(100, (index) => const Offset(0, 0));
  List<Offset> receiptOriginPosition =
      List.generate(100, (index) => const Offset(0, 0));
  List<double> receiptAngle = List.generate(100, (index) => 0);
  void initializeReceiptPosition(Size size) {
    int lineNum = 4;
    double gridheight = (size.height - 300) / lineNum;
    double gridwidth = size.width / lineNum;
    Random random = Random();
    for (int i = 0; i < lineNum * 2.5; i++) {
      for (int j = 0; j < lineNum * 2.5; j++) {
        double randomX = random.nextDouble() * gridwidth + gridwidth * (i % 4);
        double randomY =
            random.nextDouble() * gridheight + gridheight * (j % 4);
        Offset newOffset = Offset(randomX, randomY);
        receiptPosition[i * 10 + j] = newOffset;
        receiptAngle[i * 10 + j] = (random.nextDouble() - 0.5) * 20;
      }
    }
    notifyListeners();
  }

  void startReceiptMoving(index) {
    receiptOriginPosition[index] = receiptPosition[index];
    notifyListeners();
  }

  void updateReceiptPosition(offsetFromOrigin, index) {
    receiptPosition[index] = receiptOriginPosition[index] + offsetFromOrigin;
    notifyListeners();
  }

  void openManagement(id) {
    if (id == "default") {
      count = 0;
      isOpened = false;
    } else {
      if (receiptId != id || count.isEven) {
        isOpened = true;
        receiptId = id;
        count = 1;
      } else {
        isOpened = false;
        count++;
      }
    }
    notifyListeners();
  }
}

final checkSettlementPaperProvider =
    ChangeNotifierProvider((ref) => CheckSettlementPaper());
final bottomSheetSliderProvider =
    ChangeNotifierProvider<BottomSheetSlider>((ref) => BottomSheetSlider());
final readMoreProvider = StateNotifierProvider((ref) => ReadMore());
final isReceiptOpenedProvider =
    ChangeNotifierProvider((ref) => IsReceiptOpened());

class SettlementPage extends ConsumerStatefulWidget {
  const SettlementPage({super.key, required this.settlementId});
  final String settlementId;

  @override
  ConsumerState<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends ConsumerState<SettlementPage> {
  bool isFirstBuild = true;
  @override
  void initState() {
    super.initState();
    isFirstBuild = true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final provider = ref.watch(stmProvider);
    final bottomsheetprovider = ref.watch(bottomSheetSliderProvider);
    final providerMethod = ref.watch(stmProvider.notifier);
    final receiptprovider = ref.watch(isReceiptOpenedProvider);
    final checkprovider = ref.watch(checkSettlementPaperProvider);

    if (isFirstBuild) {
      bottomsheetprovider.setBottomSheetSlider(0.0, 0.0, size.height * 0.7);
      providerMethod.settingSettlementViewModel(widget.settlementId);
      checkprovider.setting();
      isFirstBuild = false;
      // while (provider.receipts.isEmpty) {
      //   Future.delayed(const Duration(milliseconds: 100));
      // }
      Future(() => receiptprovider.initializeReceiptPosition(size));
    }

    return Scaffold(
      appBar: AppBar(),
      body: const Stack(
        children: [
          SettlementInteractiveViewer(),
          SlidableAdderWidget(),
          GroupUserBar(),
          ReceiptDetail(),
          ReadMoreWidget(),
          CustomBottomSheet(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 0,
        isIn: false,
      ),
    );
  }
}

class ReceiptDetail extends ConsumerStatefulWidget {
  const ReceiptDetail({super.key});

  @override
  ConsumerState<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends ConsumerState<ReceiptDetail> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider);
    final openedprovider = ref.watch(isReceiptOpenedProvider);
    return Positioned(
      right: 0,
      top: 100,
      child: AnimatedContainer(
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(10),
        width: openedprovider.isOpened ? 300 : 0,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 270,
                  height: 30,
                  margin: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    provider.receipts[openedprovider.receiptId]?.receiptName ??
                        "Default Receipt Name",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 290,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          provider
                                  .receiptItems[ref
                                      .watch(isReceiptOpenedProvider)
                                      .receiptId]
                                  ?.length ??
                              0, (index) {
                        return SettlementPageReceiptItem(
                          index: index,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReadMoreWidget extends ConsumerStatefulWidget {
  const ReadMoreWidget({super.key});

  @override
  ConsumerState<ReadMoreWidget> createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends ConsumerState<ReadMoreWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmProvider);
    return Positioned(
      right: 0,
      bottom: ref.watch(readMoreProvider) as double,
      child: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                ref.watch(readMoreProvider.notifier).leaveReadMore();
              },
            ),
          ),
          Positioned(
            right: 30,
            bottom: 100,
            child: DragTarget(
              onLeave: (data) {
                ref.watch(readMoreProvider.notifier).leaveReadMore();
              },
              builder: (context, cadidateData, rejectedData) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: ref.watch(readMoreProvider) as double == 0 ? 300 : 10,
                  width: ref.watch(readMoreProvider) as double == 0 ? 300 : 300,
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
                            provider.settlementUsers.length ~/ 4 + 1,
                            (index) {
                              return Row(
                                children: List.generate(
                                  math.min(
                                      4,
                                      provider.settlementUsers.length -
                                          4 * index),
                                  (iindex) {
                                    return SettlementPageGroupUser(
                                      index: index * 4 + iindex,
                                      ovalSize: 45,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomSheet extends ConsumerStatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  ConsumerState<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends ConsumerState<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmProvider);
    final bottomsheetprovider = ref.watch(bottomSheetSliderProvider);
    final bottomsheetproviderMethod =
        ref.watch(bottomSheetSliderProvider.notifier);
    final checkprovider = ref.watch(checkSettlementPaperProvider);
    final checkproviderMethod =
        ref.watch(checkSettlementPaperProvider.notifier);
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              bottomsheetproviderMethod.updateHeight(-details.delta.dy);
            },
            onVerticalDragEnd: (details) {
              bottomsheetproviderMethod.updateOpenState();
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
                    child: bottomsheetprovider.isOpen
                        ? const Icon(Icons.keyboard_arrow_down_outlined)
                        : const Icon(Icons.keyboard_arrow_up_outlined),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              bottomsheetproviderMethod.updateHeight(-details.delta.dy);
            },
            onVerticalDragEnd: (details) {
              bottomsheetproviderMethod.updateOpenState();
            },
            child: AnimatedContainer(
              duration: (bottomsheetprovider.currentHeight -
                              bottomsheetprovider.previousHeight)
                          .abs() >
                      20
                  ? const Duration(milliseconds: 300)
                  : const Duration(milliseconds: 10),
              curve: Curves.decelerate,
              height: bottomsheetprovider.currentHeight,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      1 + provider.settlementUsers.length,
                                      (index) {
                                    if (index < 1) {
                                      return GestureDetector(
                                        onTap: () {
                                          checkproviderMethod.selectUser(
                                              "default", "전체 정산서");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                checkprovider.selectedUserId ==
                                                        "default"
                                                    ? colorGrey
                                                    : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 15),
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
                                              const SizedBox(
                                                width: 80,
                                                child: Text(
                                                  "전체 정산서",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          checkproviderMethod.selectUser(
                                              provider
                                                  .settlementUsers[index - 1]
                                                  .serviceUserId,
                                              provider
                                                  .settlementUsers[index - 1]
                                                  .name);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                checkprovider.selectedUserId ==
                                                        provider
                                                            .settlementUsers[
                                                                index - 1]
                                                            .serviceUserId
                                                    ? colorGrey
                                                    : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              ClipOval(
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                  "${provider.settlementUsers[index - 1].name}"),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 2,
                          width: size.width,
                          color: Colors.grey[300],
                        ),
                        Column(
                          children: [
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Text(
                                checkprovider.selectedUserName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const CheckSettlementPaperWidget(),
                          ],
                        ),
                        const Divider(
                          indent: 20,
                          endIndent: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "합계금액",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  checkprovider.selectedUserId == "default"
                                      ? "${priceToString.format(provider.finalSettlement.isEmpty ? 0 : provider.finalSettlement.map((userId) => provider.settlementPapers[userId]?.totalPrice ?? 0).reduce((value, element) => value + element))} 원"
                                      : "${priceToString.format(provider.settlementPapers[checkprovider.selectedUserId]?.totalPrice ?? 0)} 원",
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                    color: color2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                          height: 60,
                          width: size.width,
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  contentTextStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  content: const SizedBox(
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("정산은 이 정산서 대로 저장됩니다."),
                                        Text("정산을 완료 하시겠습니까?"),
                                      ],
                                    ),
                                  ),
                                  actionsPadding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  actions: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      height: 50,
                                      width: size.width,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          await provider.completeSettlement();
                                          Navigator.of(context).pop();
                                          context.go(
                                              "/SettlementPage/:settlementId/CompleteSettlementMatching");
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: color1,
                                          side: const BorderSide(
                                            color: color1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "정산 완료하기",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: size.width,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "취소",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color2,
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "정산 완료하기",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
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
    );
  }
}

class CheckSettlementPaperWidget extends ConsumerStatefulWidget {
  const CheckSettlementPaperWidget({super.key});

  @override
  ConsumerState<CheckSettlementPaperWidget> createState() =>
      _CheckSettlementPaperWidgetState();
}

class _CheckSettlementPaperWidgetState
    extends ConsumerState<CheckSettlementPaperWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmProvider);
    final checkprovider = ref.watch(checkSettlementPaperProvider);
    return Container(
      height: 300,
      width: size.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
              checkprovider.selectedUserId == "default"
                  ? provider.finalSettlement.length
                  : provider.settlementPapers[checkprovider.selectedUserId]
                          ?.settlementItems.length ??
                      0, (index) {
            String userId = checkprovider.selectedUserId == "default"
                ? provider.finalSettlement[index]
                : checkprovider.selectedUserId;
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 80,
                    child: Text(
                      checkprovider.selectedUserId == "default"
                          ? provider
                                  .settlementPapers[
                                      provider.finalSettlement[index]]
                                  ?.userName ??
                              "그룹원"
                          : provider
                                  .settlementItems[checkprovider.selectedUserId]
                                      ?[index]
                                  .menuName ??
                              "menu",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: checkprovider.selectedUserId == "default"
                              ? provider.settlementPapers[userId]
                                          ?.settlementItems[0] ==
                                      null
                                  ? "menu"
                                  : provider
                                      .settlementItems[userId]![0].menuName
                              : "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: checkprovider.selectedUserId == "default"
                              ? "등 ${provider.settlementItems[userId]?.length ?? 0} 메뉴"
                              : "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      checkprovider.selectedUserId == "default"
                          ? "${priceToString.format(provider.settlementPapers[userId]?.totalPrice ?? 0)}원"
                          : "${priceToString.format(provider.settlementItems[userId]?[index].price ?? 0)}원",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: color2,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class SettlementInteractiveViewer extends ConsumerStatefulWidget {
  const SettlementInteractiveViewer({super.key});

  @override
  ConsumerState<SettlementInteractiveViewer> createState() =>
      _SettlementInteractiveViewerState();
}

class _SettlementInteractiveViewerState
    extends ConsumerState<SettlementInteractiveViewer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmProvider);
    final openedprovider = ref.watch(isReceiptOpenedProvider);
    return InteractiveViewer(
      minScale: 1.0,
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
            width: size.width,
            height: size.height,
            child: GestureDetector(
              onTap: () {
                openedprovider.openManagement("default");
              },
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: List.generate(provider.receipts.length, (index) {
                String id = provider.receipts.keys.toList()[index];
                return SettlementPageReceipt(
                  index: index,
                  id: id,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupUserBar extends ConsumerStatefulWidget {
  const GroupUserBar({super.key});

  @override
  ConsumerState<GroupUserBar> createState() => _GroupUserBarState();
}

class _GroupUserBarState extends ConsumerState<GroupUserBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(stmProvider);
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
                      ref.watch(readMoreProvider.notifier).clickReadMore();
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
            SizedBox(
              width: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    provider.settlementUsers.length,
                    (index) {
                      return SettlementPageGroupUser(
                        index: index,
                        ovalSize: 50,
                      );
                    },
                  ),
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
  const SlidableAdderWidget({super.key});

  @override
  ConsumerState<SlidableAdderWidget> createState() =>
      _SlidableAdderWidgetState();
}

class _SlidableAdderWidgetState extends ConsumerState<SlidableAdderWidget> {
  final slidableAdderStateNotifierProvider =
      StateNotifierProvider((ref) => SlidableAdder());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                ..setEntry(3, 2, 0.001)
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

class SettlementPageReceiptItem extends ConsumerStatefulWidget {
  const SettlementPageReceiptItem({super.key, required this.index});
  final int index;

  @override
  ConsumerState<SettlementPageReceiptItem> createState() =>
      _SettlementPageReceiptItemState();
}

class _SettlementPageReceiptItemState
    extends ConsumerState<SettlementPageReceiptItem> {
  bool isSelected = false;
  bool dragTargeted = false;
  PageController pageController = PageController();
  late int itemIndex;
  @override
  void initState() {
    super.initState();
    itemIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider);
    final openedprovider = ref.watch(isReceiptOpenedProvider);
    return SizedBox(
      width: 270,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: DragTarget(
              onWillAccept: (data) {
                dragTargeted = !dragTargeted;
                return true;
              },
              onLeave: (data) {
                dragTargeted = !dragTargeted;
              },
              onAccept: (String data) {
                dragTargeted = !dragTargeted;
                provider.addSettlementItem(
                    openedprovider.receiptId,
                    itemIndex,
                    provider.receiptItems[openedprovider.receiptId]?[itemIndex]
                            .receiptItemId ??
                        "default",
                    data);
              },
              builder: (context, candidateData, rejectedData) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isSelected ? 190 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: dragTargeted ? Colors.black26 : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFCCCCCC),
                        offset: Offset(0, 2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                provider
                                        .receiptItems[openedprovider.receiptId]
                                            ?[itemIndex]
                                        .menuName ??
                                    "menu",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                "${priceToString.format(provider.receiptItems[openedprovider.receiptId]?[itemIndex].menuPrice ?? 0)} 원",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        isSelected
                            ? Container(
                                height: 150,
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: pageController,
                                        children: List.generate(
                                          ((provider
                                                              .receiptItems[
                                                                  openedprovider
                                                                      .receiptId]
                                                                  ?[itemIndex]
                                                              .serviceUsers
                                                              .length ??
                                                          0) -
                                                      1) ~/
                                                  8 +
                                              1,
                                          (ndex) {
                                            return Column(
                                              children: List.generate(
                                                math.min(
                                                    2,
                                                    ((provider
                                                                        .receiptItems[
                                                                            openedprovider.receiptId]
                                                                            ?[
                                                                            itemIndex]
                                                                        .serviceUsers
                                                                        .length ??
                                                                    0) -
                                                                1 -
                                                                ndex * 8) ~/
                                                            4 +
                                                        1),
                                                (index) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: List.generate(
                                                      math.min(
                                                          4,
                                                          ((provider
                                                                      .receiptItems[
                                                                          openedprovider
                                                                              .receiptId]
                                                                          ?[
                                                                          itemIndex]
                                                                      .serviceUsers
                                                                      .length ??
                                                                  0) -
                                                              8 * ndex -
                                                              4 * index)),
                                                      (iindex) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(10,
                                                                  0, 10, 10),
                                                          height: 60,
                                                          width: 35,
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                top: 10,
                                                                child: ClipOval(
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 40,
                                                                child: SizedBox(
                                                                  width: 30,
                                                                  child: Text(
                                                                    "${provider.receiptItems[openedprovider.receiptId]?[itemIndex].serviceUsers.values.toList()[ndex * 8 + index * 4 + iindex]}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 20,
                                                                top: 3,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    provider.deleteSettlementItem(
                                                                        openedprovider
                                                                            .receiptId,
                                                                        itemIndex,
                                                                        provider.receiptItems[openedprovider.receiptId]?[itemIndex].serviceUsers.keys.toList()[ndex * 8 +
                                                                                index * 4 +
                                                                                iindex] ??
                                                                            "default");
                                                                  },
                                                                  child:
                                                                      const SizedBox(
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 150,
                                      child: Align(
                                        alignment: const Alignment(0, 0.3),
                                        child: Text(
                                          "${provider.receiptItems[openedprovider.receiptId]?[itemIndex].serviceUsers.length ?? 0} 명",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: List.generate(
                                          math.min(
                                              provider
                                                      .receiptItems[
                                                          openedprovider
                                                              .receiptId]
                                                          ?[itemIndex]
                                                      .serviceUsers
                                                      .length ??
                                                  0,
                                              4), (index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Text(
                                            "${provider.receiptItems[openedprovider.receiptId]?[itemIndex].serviceUsers.values.toList()[index]}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "${provider.receiptItems[openedprovider.receiptId]?[itemIndex].serviceUsers.length ?? 0}명",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class SettlementPageReceipt extends ConsumerStatefulWidget {
  const SettlementPageReceipt(
      {super.key, required this.index, required this.id});
  final String id;
  final int index;

  @override
  ConsumerState<SettlementPageReceipt> createState() =>
      _SettlementPageReceiptState();
}

class _SettlementPageReceiptState extends ConsumerState<SettlementPageReceipt> {
  late String id;
  late int index;
  bool isSelected = false;
  bool isDragged = false;
  @override
  void initState() {
    super.initState();
    index = widget.index;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider);
    final receiptprovider = ref.watch(isReceiptOpenedProvider);
    return Positioned(
      top: receiptprovider.receiptPosition[index].dy,
      left: receiptprovider.receiptPosition[index].dx,
      child: Transform(
        transform:
            Matrix4.rotationZ(receiptprovider.receiptAngle[index] * pi / 180),
        child: GestureDetector(
          onLongPressStart: (details) {
            receiptprovider.startReceiptMoving(index);
          },
          onLongPressMoveUpdate: (details) {
            receiptprovider.updateReceiptPosition(
                details.offsetFromOrigin, index);
          },
          onTap: () {
            isSelected = !isSelected;
            ref.watch(isReceiptOpenedProvider.notifier).openManagement(id);
          },
          child: DragTarget(
            onWillAccept: (data) {
              isDragged = !isDragged;
              return true;
            },
            onLeave: (data) {
              isDragged = !isDragged;
            },
            onAccept: (data) {
              isDragged = !isDragged;
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 100,
                height: 130,
                decoration: BoxDecoration(
                  color: isDragged ? Colors.black26 : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 120,
                    ),
                    Positioned(
                      top: 5,
                      left: 47,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 5,
                      child: Text(
                        provider.receipts[id]?.receiptName ?? "",
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 5,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: provider.receiptItems[id]?[0].menuName ??
                                  "menu",
                              style: const TextStyle(
                                fontSize: 9,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " 등 ${provider.receipts[widget.id]?.receiptItems.length ?? "X"} 항목",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 5,
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(
                                min(
                                    2,
                                    provider.receiptItems[id]
                                            ?.map((receiptItem) => receiptItem
                                                .serviceUsers.values
                                                .toSet())
                                            .reduce((value, element) =>
                                                value.union(element))
                                            .length ??
                                        0), (index) {
                              return Text(
                                "${provider.receiptItems[id]?.map((receiptItem) => receiptItem.serviceUsers.values.toSet()).reduce((value, element) => value.union(element)).toList()[index]} ",
                              );
                            }),
                          ),
                          Text(
                            (provider.receiptItems[id]
                                            ?.map((receiptItem) => receiptItem
                                                .serviceUsers.values
                                                .toSet())
                                            .reduce((value, element) =>
                                                value.union(element))
                                            .length ??
                                        0) ==
                                    0
                                ? ""
                                : " 등 ${provider.receiptItems[id]?.map((receiptItem) => receiptItem.serviceUsers.values.toSet()).reduce((value, element) => value.union(element)).length ?? 0} 명",
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 100,
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "합계 금액",
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              "${priceToString.format((provider.receiptItems[id] == null) ? 0 : provider.receiptItems[id]!.map((receiptItem) => receiptItem.menuPrice).reduce((value, element) => (value ?? 0) + (element ?? 0)))}원",
                              style: const TextStyle(
                                fontSize: 15,
                                color: color1,
                              ),
                            ),
                          ],
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
    final provider = ref.watch(stmProvider);
    return GestureDetector(
      child: LongPressDraggable(
        delay: const Duration(
          milliseconds: 300,
        ),
        data: provider.settlementUsers[index].serviceUserId,
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
              child: Text(provider.settlementUsers[index].name ?? "그룹원"),
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
              child: Text(provider.settlementUsers[index].name ?? "그룹원$index"),
            ),
          ],
        ),
      ),
    );
  }
}
