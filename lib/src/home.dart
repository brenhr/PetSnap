import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/src/petSwipeCardsWidget.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'new_post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts',
      debugShowCheckedModeBanner: false,
      home: Posts(),
    );
  }
}

class Posts extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Posts> with SingleTickerProviderStateMixin {

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Widget> _cardLost = [];
  List<Widget> _cardFound = [];
  late TabController _tabcontroller;

  @override
  void initState() {
    super.initState();
    _tabcontroller =  TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLost();
      getFound();
    });
  }

  @override
  void dispose() {
    _tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var sizeLost = _cardLost.length;
    var sizeFound = _cardFound.length;
    
    print("Card lost size: $sizeLost");
    print("Card found size: $sizeFound");
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('PetSnap'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lightBlue[900],
            bottom: TabBar(
              controller: _tabcontroller,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Lost', icon: Icon(Icons.crisis_alert)),
                Tab(text: 'Found', icon: Icon(Icons.favorite)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabcontroller,
            children: [
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cardLost.length,
                  itemBuilder: (context, index) {
                    return _cardLost[index];
                  },
                ),
              ),
              PetSwipeCards()
              // SingleChildScrollView(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: _cardFound.length,
              //     itemBuilder: (context, index) {
              //       return _cardFound[index];
              //     },
              //   )
              // ),
            ],

          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightBlue[900],
            foregroundColor: Colors.white,
            onPressed: () {
              print(_tabcontroller.index);
              if (_tabcontroller.index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(),
                  ),
                );

              }
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _card(String petName, String city, String imageUrl) {
    print("Creating card...");
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(imageUrl),
          ListTile(
            title: Text(petName),
            subtitle: Text(
              city,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          
        ],
      ),
    );
  }

  Future<void> getLost() async {
    db.collectionGroup("Lost")
      .where("found", isEqualTo: false)
      .get().then((val){
          if(val.docs.length > 0){
            val.docs.forEach((doc) {
              var petName = doc.data()["name"];
              var city = doc.data()["city"];
              var imageUrl = doc.data()["picture"];
              print("Data: $petName, $city, $imageUrl");
              _cardLost.add(_card(petName, city, imageUrl));
              setState(() {
                
              });
            });
          }
          else{
              print("Lost Pets Not Found");
          }
      });
  }

  Future<void> getFound() async {
    db.collectionGroup("Found")
      .where("ownerFound", isEqualTo: false)
      .get().then((val){
          if(val.docs.length > 0){
            val.docs.forEach((doc) {
              var petName = doc.data()["name"];
              var city = doc.data()["city"];
              var imageUrl = doc.data()["picture"];
              print("Data: $petName, $city, $imageUrl");
              _cardFound.add(_card(petName, city, imageUrl));
              setState(() {
                
              });
            });
          }
          else{
              print("Found Pets Not Found");
          }
      });
  }
}

