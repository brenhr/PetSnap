import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   static const route = '/home';
//
//   @override
//   Widget build(BuildContext context) {
//     return HomePage();
//   }
//
// }

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text("PetSnap"),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => CameraPreview(appState.cameraController)
      ),
      // body: Text("Hello World!"),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: [
      //     Text("EntriesPage"),
      //     Text("StatisticsPage"),
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Snap',
        isExtended: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.photo_camera),
        //TODO onPressed functionality
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt)),
              Tab(icon: Icon(Icons.insert_chart)),
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
