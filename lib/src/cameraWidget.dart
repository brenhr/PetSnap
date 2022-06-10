import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a picture"),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Column(
            children: [
              Expanded(child: Center(child: CameraPreview(appState.cameraController))),
            ],
          );
           // return Expanded(child: CameraPreview(appState.cameraController));
        },
      )
    );
  }

}