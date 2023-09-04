import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestClass {
  TestClass();

  int a = 0;
  List<int> b = [];

  void classIncrement() => a++;
}

class NotifierTest extends Notifier<TestClass> {
  @override
  TestClass build() {
    return TestClass();
  }

  void increment() => state.a++;
}

class StateNotifierTest extends StateNotifier {
  StateNotifierTest() : super(0);

  void increment() => state++;
}

class ChangeNotifierTest extends ChangeNotifier {
  final testClass = TestClass();

  void increment() {
    testClass.a++;
    notifyListeners();
  }
}

// Notifier, StateNotifier, ChangeNotifier사용해봄
// StateProvider, StreamProvider, FutureProvider 해봐야됨
// ChangeNotifier를 이용해야만 화면을 바꿀 수 있다 나머지는 값은 바뀜
final notifierProvider =
    NotifierProvider<NotifierTest, TestClass>(() => NotifierTest());
final stateNotifierProvider =
    StateNotifierProvider((ref) => StateNotifierTest());
final changeNotifierProvider =
    ChangeNotifierProvider<ChangeNotifierTest>((ref) => ChangeNotifierTest());

class GunPage extends StatefulWidget {
  const GunPage({super.key});

  @override
  State<GunPage> createState() => _GunPageState();
}

class _GunPageState extends State<GunPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gun Page"),
      ),
      body: Column(
        children: [
          TestContainer1(
            size: size,
            color: const Color.fromARGB(255, 100, 100, 100),
          ),
          TestContainer2(
            size: size,
            color: const Color.fromARGB(255, 120, 120, 120),
          ),
          TestContainer3(
            size: size,
            color: const Color.fromARGB(255, 140, 140, 140),
          )
        ],
      ),
    );
  }
}

//global로 선언된 Provider는 화면전환에 영향을 안받고 모두 같은 값을 공유한다
//local로 선언된 Provider는 화면전환시 값이 초기화 되고 각자 다른 값을 가진다
class TestContainer1 extends ConsumerStatefulWidget {
  const TestContainer1({super.key, required this.size, required this.color});
  final Size size;
  final Color color;

  @override
  ConsumerState<TestContainer1> createState() => _TestContainerState1();
}

class _TestContainerState1 extends ConsumerState<TestContainer1> {
  final statefulWidgetChangeNotifierProvider =
      ChangeNotifierProvider((ref) => ChangeNotifierTest());

  @override
  void initState() {
    super.initState();
    ref.read(changeNotifierProvider);
    ref.read(stateNotifierProvider);
    ref.read(statefulWidgetChangeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final statefulWidgetChangeNotifierProvidervalue =
        ref.watch(statefulWidgetChangeNotifierProvider);
    final changeNotifierProviderValue = ref.watch(changeNotifierProvider);
    // final stateNotifierProviderValue = ref.watch(stateNotifierProvider);
    return Container(
      height: widget.size.height * 0.2,
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: 10,
            child: ElevatedButton(
              child: const Text("Button"),
              onPressed: () {
                ref.watch(changeNotifierProvider.notifier).increment();
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 150,
            child: Draggable(
              data: 1,
              feedback: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
              ),
              childWhenDragging: const SizedBox(),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: const Center(
                  child: Text("Draggable"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 250,
            child: DragTarget(
              builder: (context, accepted, rejected) {
                return Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: const Text(
                    "Drag Target",
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onAccept: (int data) {
                ref
                    .watch(statefulWidgetChangeNotifierProvider.notifier)
                    .increment();
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 150,
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Success Counter Local: ${statefulWidgetChangeNotifierProvidervalue.testClass.a}"),
                    Text(
                      "Success Counter Global: ${changeNotifierProviderValue.testClass.a}",
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

//class 내부 함수로 값을 변경하더라도 그 결과가 바뀌게 하려면 ChangeNorifier안에 있어야한다
class TestContainer2 extends ConsumerStatefulWidget {
  const TestContainer2({super.key, required this.size, required this.color});
  final Size size;
  final Color color;

  @override
  ConsumerState<TestContainer2> createState() => _TestContainerState2();
}

class _TestContainerState2 extends ConsumerState<TestContainer2> {
  final statefulWidgetChangeNotifierProvider =
      ChangeNotifierProvider((ref) => ChangeNotifierTest());

  @override
  void initState() {
    super.initState();
    ref.read(changeNotifierProvider);
    ref.read(stateNotifierProvider);
    ref.read(statefulWidgetChangeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final statefulWidgetChangeNotifierProvidervalue =
        ref.watch(statefulWidgetChangeNotifierProvider);
    final changeNotifierProviderValue = ref.watch(changeNotifierProvider);
    // final stateNotifierProviderValue = ref.watch(stateNotifierProvider);
    return Container(
      height: widget.size.height * 0.2,
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: 10,
            child: ElevatedButton(
              child: const Text("Button"),
              onPressed: () {
                ref.watch(changeNotifierProvider.notifier).increment();
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 150,
            child: Draggable(
              data: 1,
              feedback: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
              ),
              childWhenDragging: const SizedBox(),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: const Center(
                  child: Text("Draggable"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 250,
            child: DragTarget(
              builder: (context, accepted, rejected) {
                return Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: const Text(
                    "Drag Target",
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onAccept: (int data) {
                ref
                    .watch(statefulWidgetChangeNotifierProvider.notifier)
                    .testClass
                    .classIncrement();
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 150,
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Success Counter Local: ${statefulWidgetChangeNotifierProvidervalue.testClass.a}"),
                    Text(
                      "Success Counter Global: ${changeNotifierProviderValue.testClass.a}",
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

//Notifier로 선언된 친구는 build를 다시 해줘야 한다
class TestContainer3 extends ConsumerStatefulWidget {
  const TestContainer3({super.key, required this.size, required this.color});
  final Size size;
  final Color color;

  @override
  ConsumerState<TestContainer3> createState() => _TestContainerState3();
}

class _TestContainerState3 extends ConsumerState<TestContainer3> {
  final statefulWidgetChangeNotifierProvider =
      ChangeNotifierProvider((ref) => ChangeNotifierTest());

  @override
  void initState() {
    super.initState();
    ref.read(notifierProvider);
    ref.read(stateNotifierProvider);
    ref.read(changeNotifierProvider);
    ref.read(statefulWidgetChangeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final statefulWidgetChangeNotifierProvidervalue =
        ref.watch(statefulWidgetChangeNotifierProvider);
    // final changeNotifierProviderValue = ref.watch(changeNotifierProvider);
    // final stateNotifierProviderValue = ref.watch(stateNotifierProvider);
    final notifierProviderValue = ref.watch(notifierProvider);
    return Container(
      height: widget.size.height * 0.2,
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: 10,
            child: ElevatedButton(
              child: const Text("Button"),
              onPressed: () {
                ref.watch(notifierProvider.notifier).increment();
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 150,
            child: Draggable(
              data: 1,
              feedback: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
              ),
              childWhenDragging: const SizedBox(),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: const Center(
                  child: Text("Draggable"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 250,
            child: DragTarget(
              builder: (context, accepted, rejected) {
                return Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: const Text(
                    "Drag Target",
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onAccept: (int data) {
                ref
                    .watch(statefulWidgetChangeNotifierProvider.notifier)
                    .increment();
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 150,
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Success Counter Local: ${statefulWidgetChangeNotifierProvidervalue.testClass.a}"),
                    Text(
                      "Success Counter Notifier: ${notifierProviderValue.a}",
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
