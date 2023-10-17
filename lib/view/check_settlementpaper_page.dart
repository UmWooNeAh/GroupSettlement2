import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/viewmodel/settlement_view_model.dart';

class CheckSettlementPaper extends ConsumerStatefulWidget {
  const CheckSettlementPaper({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<CheckSettlementPaper> createState() =>
      _CheckSettlementPaperState();
}

class _CheckSettlementPaperState extends ConsumerState<CheckSettlementPaper> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stmProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
