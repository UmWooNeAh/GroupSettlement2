import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settlementDetailPage extends StatefulWidget {
  const settlementDetailPage({Key? key}) : super(key: key);

  @override
  State<settlementDetailPage> createState() => _settlementDetailPageState();
}

class _settlementDetailPageState extends State<settlementDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("Detail Page")
    );
  }
}
