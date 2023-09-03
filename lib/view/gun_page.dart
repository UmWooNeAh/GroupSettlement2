import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_element.dart';

class Counter extends StateNotifier{
  Counter() : super(0);

  void increment() => state++;
}

class GunPage extends ConsumerStatefulWidget {
  const GunPage({super.key});

  @override
  ConsumerState<GunPage> createState() => _GunPageState();
}

class _GunPageState extends ConsumerState<GunPage> {
  final counterProvider = StateNotifierProvider((ref) => Counter());

  @override
  void initState(){
    super.initState();
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(counterProvider);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Gun Page"),),
      body: Column(
        children: [
          Container(height: size.height * 0.2, color: Colors.grey[600],
            child: Stack(
              children: [
                Positioned(
                  top: 5, left: 10,
                  child: ElevatedButton(
                    child: const Text("Button"),
                    onPressed: (){},
                  ),
                ),
                Positioned(
                  top: 10, left: 150,
                  child: Draggable(
                    data: 1,
                    feedback: Container(height: 40, width: 80, decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),),
                    child: Container(height: 40, width: 80, decoration: BoxDecoration(
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
                    builder: (context, accepted, rejected){
                      return Container(
                        height: 40, width: 70, decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                        child: const Text("Drag Target", textAlign: TextAlign.center,),
                      );
                    },
                    onAccept: (int data){
                      ref.watch(counterProvider.notifier).increment();
                      print(ref.watch(counterProvider));
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
                    child: Center(child: Text("Success Counter: $value"),),
                  ),
                ),
              ],
            ),
          ),
          Container(height: size.height * 0.2, color: Colors.grey[700],
            child: Container(),
          ),
          Container(height: size.height * 0.2, color: Colors.grey[800]),
          Container(height: size.height * 0.2, color: Colors.grey[850]),
        ],
      ),
    );
  }
}
