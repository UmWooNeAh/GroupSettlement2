import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
    final gvm = ref.watch(stmCreateProvider);
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();

    return Scaffold(
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CameraPreview(_controller);
            } else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async{
            try {
              await _initializeControllerFuture;

              final path = join(
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png'
              );

              final image = await _controller.takePicture();
            }catch(e){
              print(e);
            }
          },
        ),
    );
  }
}
