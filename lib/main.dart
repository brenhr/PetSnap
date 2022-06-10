import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';
import 'src/home.dart';

import 'src/loginPageWidget.dart';
// import 'src/homePageWidget.dart';
import 'src/cameraWidget.dart';
import 'src/new_post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => PetSnap(),
    ),
  );
}

class PetSnap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetSnap',
      theme: ThemeData(colorScheme: ColorScheme.light()),
      // home: LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/camera': (context) => CameraPage(),
        '/newpost': (context) => PostPage(),
      }
    );
  }
}

class ApplicationState extends ChangeNotifier {


  ApplicationState() {
    init();
  }

  Future<void> init() async {
    print("Init app PetSnap...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
