import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groupsettlement2/design_element.dart';
import '../viewmodel/SettlementViewModel.dart';
import 'dart:math';

class CompleteSettlementMatching extends ConsumerStatefulWidget {
  const CompleteSettlementMatching({super.key});

  @override
  ConsumerState<CompleteSettlementMatching> createState() =>
      _CompleteSettlementMatchingState();
}

class _CompleteSettlementMatchingState
    extends ConsumerState<CompleteSettlementMatching>
    with TickerProviderStateMixin {
  late final AnimationController _animation;
  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 1,
    )..repeat();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double leftright = size.width * 1.1;
    double topbottom = size.height * 0.6;
    double speed = size.height * 0.3;
    double rotation = pi / 4.5;
    Curve curve = Curves.decelerate;
    Duration duration = const Duration(milliseconds: 0);
    final provider = ref.watch(stmProvider);
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return AnimatedPositioned(
                curve: curve,
                duration: duration,
                bottom: topbottom + max(_animation.value * 2 - 1, 0) * speed,
                left: leftright -
                    max(_animation.value * 2 - 1, 0) *
                        speed *
                        (1 / tan(rotation)),
                child: Transform(
                  transform: Matrix4.rotationZ(rotation),
                  origin: const Offset(0, 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 800,
                    height: 300,
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return AnimatedPositioned(
                curve: curve,
                duration: duration,
                top: topbottom + min(_animation.value * 2, 1) * speed,
                right: leftright -
                    min(_animation.value * 2, 1) * speed * (1 / tan(rotation)),
                child: Transform(
                  transform: Matrix4.rotationZ(rotation),
                  origin: const Offset(800, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 800,
                    height: 300,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: const Alignment(0, -0.05),
            child: SizedBox(
              width: size.width * 0.85,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              provider.group.groupName ?? "default group Name",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: " 그룹의 정산,",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: provider.settlement.settlementName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: "을 ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text: "저장",
                      style: TextStyle(
                          fontSize: 20,
                          color: color1,
                          fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text: "했습니다!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ])),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.5),
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: size.width,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: color3,
                        side: const BorderSide(
                          color: Colors.transparent,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "카카오톡으로 정산서 공유하기",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    width: size.width,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: colorGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "홈으로 이동하기",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/SettlementFinalCheckPage');
                    },
                    child: const Text(
                      "정산결과확인하기",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
