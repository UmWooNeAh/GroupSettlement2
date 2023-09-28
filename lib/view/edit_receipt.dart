import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupsettlement2/view/shared_basic_widget.dart';

class EditReceiptPage extends ConsumerStatefulWidget {
  const EditReceiptPage({super.key});

  @override
  ConsumerState<EditReceiptPage> createState() => _EditReceiptState();
}

class _EditReceiptState extends ConsumerState<EditReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
