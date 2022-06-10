import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class PetSwipeCards extends StatefulWidget {
  @override
  State<PetSwipeCards> createState() => _PetSwipeCardsState();
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color}) {}
}

class _PetSwipeCardsState extends State<PetSwipeCards> {
  final Stream<QuerySnapshot> _foundedPets =
      FirebaseFirestore.instance.collectionGroup('found').snapshots();
  List<SwipeItem> _swipeItems = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  createSwipeItems(List<QueryDocumentSnapshot<Object?>> querySnapshot) {
    return querySnapshot.map((doc) {
      return SwipeItem(
        content: Content(text: "gs://petsnapmx.appspot.com/assets/IMG_20220527_143818.jpg", color: Colors.red),
        // content: Content(text: doc.id, color: doc.data()["storageRef"]),
        likeAction: () {},
        nopeAction: () {},
        superlikeAction: () {},
        onSlideUpdate: (SlideRegion? region) async {
          log("Region $region");
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _foundedPets,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        _swipeItems = createSwipeItems(snapshot.data!.docs);
        MatchEngine _matchEngine = MatchEngine(swipeItems: _swipeItems);

        return Container(
          child: Column(
            children: [
              Container(
                // height: 550,
                height: 400,
                child: SwipeCards(
                  matchEngine: _matchEngine,
                  itemBuilder: (BuildContext context, int index) {
                    return PetSwipeContent(
                        image: _swipeItems[index].content.text);
                  },
                  onStackFinished: () {},
                  itemChanged: (SwipeItem item, int index) {
                    log("Item: ${item.content.text}, index: $index");
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,

                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // _matchEngine.currentItem.nope();
                      },
                      child: Text("Nope")),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // _matchEngine.currentItem.superLike();
                  //     },
                  //     child: Text("Superlike")),
                  ElevatedButton(
                      onPressed: () {
                        // _matchEngine.currentItem.like();
                      },
                      child: Text("Founded"))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PetSwipeContent extends StatelessWidget {
  final String image;
  PetSwipeContent({required this.image}) {}

  @override
  Widget build(BuildContext context) {
    final gsReference = FirebaseStorage.instance.refFromURL(image);

    return FutureBuilder(
      future: gsReference.getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot<String> url) {
        if (url.hasError) {
          return Text('Something went wrong');
        }
        if (url.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        print(url.data!);
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url.data!),
              fit: BoxFit.cover,
            ),
          ),
          child: Text(""),
        );
      },
    );

    return Container(
      alignment: Alignment.center,
      color: Colors.red,
      child: Text(
        image,
        style: TextStyle(fontSize: 100),
      ),
    );
  }
}
