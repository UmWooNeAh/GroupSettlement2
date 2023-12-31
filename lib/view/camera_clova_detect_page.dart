import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../class/class_receiptContent.dart';
import '../viewmodel/SettlementCreateViewModel.dart';

class cameraDetectPage extends ConsumerStatefulWidget {
  final Object? extra;
  const cameraDetectPage({Key? key, required this.extra}) : super(key: key);

  @override
  ConsumerState<cameraDetectPage> createState() => _cameraDetectPageState();
}

class _cameraDetectPageState extends ConsumerState<cameraDetectPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stmcvm = ref.watch(stmCreateProvider);
    final CameraDescription camera = widget.extra as CameraDescription;
    _controller = CameraController(camera, ResolutionPreset.medium,imageFormatGroup: ImageFormatGroup.yuv420);
    _initializeControllerFuture = _controller.initialize();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Stack(
                children: [
                  Container(
                    width:double.infinity,height:double.infinity,
                    decoration: BoxDecoration(
                      color:Colors.black
                    ),
                  ),
                  Column(
                    children: [
                      CameraPreview(_controller),
                      SizedBox(height:30),
                      Text("보다 정확한 인식을 위하여 어두운 배경에서 촬영해주세요",
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
              return Center(child: CircularProgressIndicator());
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
                  child: Icon(Icons.image),
                  onPressed: () async{
                    try {
                      _controller.dispose();
                      await stmcvm.clova.pickPicture();
                      final analyzeResult = await stmcvm.clova.analyze();
                      ReceiptContent receiptContent = stmcvm.createReceiptFromNaverOCR(analyzeResult);

                      context.push("/scanedRecieptPage",extra: receiptContent);
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
                  child: Icon(Icons.camera_alt),
                  onPressed: () async{
                    try {
                      _controller.dispose();
                      await _initializeControllerFuture;

                      final image = await _controller.takePicture();
                      if (!mounted) return;
                      stmcvm.clova.getImageByFile(File(image.path));
                      final analyzeResult = stmcvm.clova.analyze();
                      ReceiptContent receiptContent = stmcvm.createReceiptFromNaverOCR(analyzeResult);

                      context.push("/scanedRecieptPage",extra: receiptContent);
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