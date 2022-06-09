import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

import 'package:camera/camera.dart';

import 'ui/home.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: MaterialApp(
        home: HomePage(),
      ),
    )
  );

  // runApp(MaterialApp(
  //   home: HomePage(),
  // ));
}

class ApplicationState implements ChangeNotifier {
  late CameraController _cameraController;

  CameraController get cameraController => _cameraController;

  set cameraController(CameraController cameraController) {
    _cameraController = cameraController;
  }

  takePicture() {
    var picture = _cameraController.takePicture();
    print(picture);
    // return _cameraController.takePicture();
  }

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    cameraController = CameraController(
        _cameras[0],
      ResolutionPreset.medium,
      // imageFormatGroup: ImageFormatGroup.jpeg,
      imageFormatGroup: ImageFormatGroup.yuv420
    );
    cameraController
        .initialize()
        .then((_) => notifyListeners())
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void addListener(VoidCallback listener) {
  }

  @override
  void dispose() {
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
  }

  @override
  void removeListener(VoidCallback listener) {
  }

}
