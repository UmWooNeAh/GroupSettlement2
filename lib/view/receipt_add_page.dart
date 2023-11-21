import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/SettlementCreateViewModel.dart';

class ReceiptAddPage extends ConsumerStatefulWidget {
  final Object camera;
  const ReceiptAddPage({Key? key, required this.camera}) : super(key: key);

  @override
  ConsumerState<ReceiptAddPage> createState() => _ReceiptAddPageState();
}

class _ReceiptAddPageState extends ConsumerState<ReceiptAddPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    final stmcvm = ref.watch(stmCreateProvider);
    final CameraDescription camera = widget.camera as CameraDescription;
    _controller = CameraController(camera, ResolutionPreset.medium,imageFormatGroup: ImageFormatGroup.yuv420);
    _initializeControllerFuture = _controller.initialize();

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Stack(
                children: [
                  Container(
                    width:double.infinity,height:double.infinity,
                    decoration: const BoxDecoration(
                      color:Colors.black
                    ),
                  ),
                  Column(
                    children: [
                      CameraPreview(_controller),
                      const SizedBox(height:30),
                      const Text("보다 정확한 인식을 위하여 어두운 배경에서 촬영해주세요",
                        style: TextStyle(
                            color:Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                ],
              );
            } else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:35),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: null,
                  child: const Icon(Icons.image),
                  onPressed: (){
                    try {
                      _controller.dispose();
                      dynamic analyzeResult;
                      Future(() async {
                        await stmcvm.clova.pickPicture().then((value) {
                          context.push('/ReceiptAdd/WaitingAnalyze');
                        });
                        analyzeResult = await stmcvm.clova.analyze();
                      }).then((value) {
                        stmcvm.createReceiptFromNaverOCR(analyzeResult);
                        context.pushReplacement("/ReceiptAdd/ReceiptCheckScanned");
                      });
                    }catch(e){
                      print(e);
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: null,
                  child: const Icon(Icons.camera_alt),
                  onPressed: () async{
                    try {
                      _controller.dispose();
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();
                      if (!mounted) return;
                      stmcvm.clova.getImageByFile(File(image.path));
                      final analyzeResult = stmcvm.clova.analyze();
                      stmcvm.createReceiptFromNaverOCR(analyzeResult);
                      context.go("/ReceiptAdd/ReceiptCheckScanned");
                    }catch(e){
                      print(e);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}

class WaitingAnalyzePage extends StatefulWidget {
  const WaitingAnalyzePage({super.key});

  @override
  State<WaitingAnalyzePage> createState() => _WaitingAnalyzePageState();
}

class _WaitingAnalyzePageState extends State<WaitingAnalyzePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Scanning..."),);
  }
}