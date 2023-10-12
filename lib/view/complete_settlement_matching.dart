import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteSettlementMatching extends ConsumerStatefulWidget {
  const CompleteSettlementMatching({super.key});

  @override
  ConsumerState<CompleteSettlementMatching> createState() =>
      _CompleteSettlementMatchingState();
}

class _CompleteSettlementMatchingState
    extends ConsumerState<CompleteSettlementMatching> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(),
    );
  }
}
