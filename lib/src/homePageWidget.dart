import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/petSwipeCardsWidget.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PetSnap"),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Text("FPp"),
          Text("EntriesPage"),
          // Text("StatisticsPage"),
          PetSwipeCards()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Snap',
          isExtended: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.photo_camera),
          onPressed: () {
            Navigator.pushNamed(context, "/camera");
          },
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search_rounded)),
              Tab(icon: Icon(Icons.chat_rounded)),
              Tab(icon: Icon(Icons.image_rounded)),
            ],
            // TODO: Tabs controller
            controller: _tabController,
            labelColor: Colors.indigo,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}