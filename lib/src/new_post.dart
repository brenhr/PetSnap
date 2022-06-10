import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'home.dart';


class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Post',
      debugShowCheckedModeBanner: false,
      home: NewPost(),
    );
  }
}

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  String? selectedValue = "Lost";
  DateTime _date = DateTime(2022, 10, 06);
  DateFormat dateFormat = DateFormat("MM-dd-yyyy");
  FirebaseFirestore db = FirebaseFirestore.instance;

  final petNameController = TextEditingController();
  final petAgeController = TextEditingController();
  final dateController = TextEditingController();
  final distinguishingFeatures = TextEditingController();
  final ownerController = TextEditingController();
  final contactPhone = TextEditingController();
  final placeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petNameController.dispose();
    petAgeController.dispose();
    dateController.dispose();
    distinguishingFeatures.dispose();
    ownerController.dispose();
    contactPhone.dispose();
    placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Add a new post',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButton(
                isExpanded: true,
                value: selectedValue,
                onChanged: (String? newValue){setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: petNameController,
                decoration: InputDecoration(
                  labelText: 'Pet name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: petAgeController,
                decoration: InputDecoration(
                  labelText: 'Pet age',
                  border: OutlineInputBorder(),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Lost/Found Date',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      _selectDate();
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Date is required';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: placeController,
                decoration: InputDecoration(
                  labelText: 'City where pet was lost or found',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'City is required';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: distinguishingFeatures,
                decoration: InputDecoration(
                  labelText: 'Distinguishing Features',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: ownerController,
                decoration: InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: contactPhone,
                decoration: InputDecoration(
                  labelText: 'Your phone number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
              onPressed: () {
                  //Ad Ricardo's widget
                },
                child: Text("Add a Picture..."),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  addPost(context);
                },
                icon: Icon(Icons.add, size: 18),
                label: Text("Add Post"),
              ),
            ),
          ],
        )
      )
    );
  }

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(2023, 1),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        dateController.text =  dateFormat.format(newDate);
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Lost"),value: "Lost"),
      DropdownMenuItem(child: Text("Found"),value: "Found"),
    ];
    return menuItems;
  }

  Future<void> addPost(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      print("User $uid is adding a post.");
      final user = {
        "name": ownerController.text,
        "phoneNumber": contactPhone.text
      };
      
      db.collection("users").doc(uid).set(user, SetOptions(merge: true));
      if(selectedValue == "Lost") {
        final pet = {
          "name": petNameController.text,
          "age": petAgeController.text,
          "lostDate": dateController.text,
          "city": placeController.text,
          "found": false,
          "distinguishingFeatures": distinguishingFeatures.text,
          "picture": "https://firebasestorage.googleapis.com/v0/b/petsnapmx.appspot.com/o/assets%2Fdog.png?alt=media&token=83695069-2538-49d1-b17a-f4b6b7f67304"
        };
        db.collection('users')
          .doc(uid)
          .collection('Lost')
          .add(pet).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
      } else {
        final pet = {
          "name": petNameController.text,
          "age": petAgeController.text,
          "foundDate": dateController.text,
          "city": placeController.text,
          "ownerFound": false,
          "distinguishingFeatures": distinguishingFeatures.text,
          "picture": "https://firebasestorage.googleapis.com/v0/b/petsnapmx.appspot.com/o/assets%2Fcat.png?alt=media&token=e091977c-bac2-4d96-99cc-374646d49b47"
        };
        db.collection('users')
          .doc(uid)
          .collection('Found')
          .add(pet).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

    } else {
      print("Error: User is not signed in");
    }

  }

  Future<void> initFirestore() async {
    print("Init Firestore...");
    db = FirebaseFirestore.instance;
  }
}