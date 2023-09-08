import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class Informations {
  List<String> receipts = [
    "영수증1",
    "영수증2",
    "영수증3",
  ];
  List<String> members = [
    "그룹원1",
    "그룹원2",
    "그룹원3",
    "그룹원1",
    "그룹원2",
    "그룹원3",
    "그룹원1",
    "그룹원2",
    "그룹원3",
    "그룹원1",
    "그룹원2",
    "그룹원3",
  ];
  Informations();
}

class Receiptss extends ChangeNotifier {
  Informations information = Informations();
}

final receiptssChangeNotifierProvider =
    ChangeNotifierProvider((ref) => Receiptss());

class SettlementPage extends ConsumerStatefulWidget {
  const SettlementPage({super.key});

  @override
  ConsumerState<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends ConsumerState<SettlementPage> {
  OverlayEntry? overlayEntry;
  int currentPageIndex = 0;
  void createHighlightOverlay({
    required AlignmentDirectional alignment,
    required Color borderColor,
  }) {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return SafeArea(
          child: Align(
            alignment: alignment,
            heightFactor: 1.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Tap here for'),
                  Builder(builder: (BuildContext context) {
                    switch (currentPageIndex) {
                      case 0:
                        return const Column(
                          children: <Widget>[
                            Text(
                              'Explore page',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                            ),
                          ],
                        );
                      case 1:
                        return const Column(
                          children: <Widget>[
                            Text(
                              'Commute page',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.green,
                            ),
                          ],
                        );
                      case 2:
                        return const Column(
                          children: <Widget>[
                            Text(
                              'Saved page',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.orange,
                            ),
                          ],
                        );
                      default:
                        return const Text('No page selected.');
                    }
                  }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 80.0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.read(receiptssChangeNotifierProvider);
  }

  double angularValue = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: size.width,
              height: size.height * 0.6,
              color: Colors.blue[100],
              child: Stack(
                children: List.generate(
                  ref
                      .watch(receiptssChangeNotifierProvider.notifier)
                      .information
                      .receipts
                      .length,
                  (index) => SettlementPageReceipt(index: index),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            width: size.width,
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("그룹원"),
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
          Container(
            height: 60,
            width: size.width,
            color: Colors.brown[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 30,
                    width: 50,
                    color: Colors.pink[100],
                    child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          createHighlightOverlay(
                            alignment: AlignmentDirectional.bottomStart,
                            borderColor: Colors.red,
                          );
                        },
                        onVerticalDragUpdate: (details) {},
                        child: const Center(child: Text("Button")))),
              ],
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

class SettlementPageReceipt extends ConsumerWidget {
  const SettlementPageReceipt({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 10,
      left: index * 120 + 10,
      child: Container(
        width: 100,
        height: 130,
        color: Colors.amberAccent,
        child: Column(
          children: [
            Text(ref
                .watch(receiptssChangeNotifierProvider.notifier)
                .information
                .receipts[index]),
          ],
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
        Text(ref
            .watch(receiptssChangeNotifierProvider.notifier)
            .information
            .members[index]),
      ],
    );
  }
}

class RotationTest extends StatefulWidget {
  const RotationTest({super.key});

  @override
  State<RotationTest> createState() => _RotationTestState();
}

class _RotationTestState extends State<RotationTest> {
  double angularValue = 0;
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
              // ..rotateX(angularValue * math.pi / 4),
              ..rotateY(angularValue * math.pi / 4),
            // ..rotateZ(angularValue * math.pi / 4),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.amber,
            ),
          ),
        ),
        Positioned(
          left: 200,
          top: 400,
          child: Draggable(
            onDragUpdate: (details) {
              // ref
              //     .watch(offsetChangeNotifierProvider.notifier)
              //     .updateOffset(details.delta);
              setState(() {
                angularValue += 0.01;
              });
              print(angularValue);
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
