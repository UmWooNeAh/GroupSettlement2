import 'package:flutter/material.dart';

class SinPage extends StatefulWidget {
  const SinPage({super.key});

  @override
  State<SinPage> createState() => _SinPageState();
}

class _SinPageState extends State<SinPage> {
  int firstSuccessCount = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(title: Text("Sin Page"),),
      body: Column(
        children: [
          Container(height: size.height * 0.2, color: Colors.grey[600],
            child: Stack(
              children: [
                Positioned(
                  top: 5, left: 10,
                  child: ElevatedButton(
                    child: const Text("Button"),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 10, left: 150,
                  child: Draggable(
                    data: 1,
                    feedback: Container(
                      height: 40, width: 80, decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),),
                    child: Container(
                      height: 40, width: 80, decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),
                      child: Center(child: Text("Draggable"),),
                    ),
                    childWhenDragging: SizedBox(),
                  ),
                ),
                Positioned(
                  top: 10, left: 250,
                  child: DragTarget(
                    builder: (context, accepted, rejected) {
                      return Container(
                        height: 40, width: 70, decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                        child: Text(
                          "Drag Target", textAlign: TextAlign.center,),
                      );
                    },
                    onAccept: (int data) {
                      setState(() {
                        firstSuccessCount += data;
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 70, left: 150,
                  child: Container(
                    height: 80, width: 200, decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                    child: Center(
                      child: Text("Success Counter: $firstSuccessCount"),),
                  ),
                ),
              ],
            ),
          ),
          Container(height: size.height * 0.2, color: Colors.grey[700]),
          Container(height: size.height * 0.2, color: Colors.grey[800]),
          Container(height: size.height * 0.2, color: Colors.grey[850]),
        ],
      ),
    );
  }
}