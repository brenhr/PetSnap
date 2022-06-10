import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/home.dart';

import 'src/cameraWidget.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } on CameraException catch (e) {
    log(e.code);
    log(e.description!);
  }

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
      }
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final bool _obscureText = true;
  bool _passwordVisible = false;
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text('PetSnap'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Login to PetSnap',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 110,
                backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/petsnapmx.appspot.com/o/assets%2Fduck-animate-1-500x500.png?alt=media&token=b5ba646a-adc5-4529-89b3-accc4a02eef4'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Email is required';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: passController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility: Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      _obscureText: false;
                      _passwordVisible = !_passwordVisible;
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Password is required';
                  }
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[900],
                    ),
                    onPressed: () {
                      signInWithEmailAndPassword(emailController.text, passController.text, context);
                    },
                    child: Text('Login')
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[900],
                    ),
                    onPressed: () {
                      registerAccount(emailController.text, passController.text);
                    },
                    child: Text('Register account')
                  )
                ),
              ]
            )
          ]
        )
      )
    );
  }

  Future <void> signInAnonymously() async {
    try {
      print("Signing in...");
      final userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      var uid = userCredential.user?.uid;
      print("Signed in with temporary account: $uid");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  Future <void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      var uid = credential.user?.uid;
      print("Signed in with id: $uid");
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future <void> registerAccount(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var uid = credential.user?.uid;
      print("Signed in with id: $uid");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> init() async {
    print("Init app PetSnap...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}

class ApplicationState extends ChangeNotifier {
  late CameraController cameraController;


  ApplicationState() {
    init();
  }

  Future<void> init() async {
    print("Init app PetSnap...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    cameraController = CameraController(_cameras[0], ResolutionPreset.max, imageFormatGroup: ImageFormatGroup.yuv420);
    cameraController.initialize().then((_) {
      notifyListeners();
    }).catchError((Object e) {
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

  cameraDispose() {
    cameraController.dispose();
  }
}
