import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/main.dart';
import 'package:flutter_practice1/router/locations.dart';
import 'package:flutter_practice1/screens/home/items_page.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:flutter_practice1/utils/logger.dart';
import 'package:flutter_practice1/widgets/expandable_fab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void toLogout() {
    setState((){
      FirebaseAuth.instance.signOut();
    });
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: NearBy',
      style: optionStyle,
    ),
    Text(
      'Index 2: Chatting',
      style: optionStyle,
    ),
    Text(
      'Index 3: MyTab',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d("홈스크린 빌드 호출");
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ItemsPage(),
          Container(color: Colors.accents[0]),
          Container(color: Colors.accents[1]),
          Container(color: Colors.accents[2]),
        ],
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.read<UserProvider>().userModel!.address, style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
          IconButton(onPressed: (){toLogout();}, icon: Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 80,
        children: [
          MaterialButton(
            onPressed: (){
              context.beamToNamed('/$LOCA_UPLOAD');
            },
          child: Icon(Icons.add, color: Colors.white,),
            color: Theme.of(context).primaryColor,
            shape: CircleBorder(),
          ),
          MaterialButton(
            onPressed: (){},
          child: Icon(Icons.add, color: Colors.white),
            color: Theme.of(context).primaryColor,
            shape: CircleBorder(),

          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "내근처"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "채팅"),
          BottomNavigationBarItem(icon: Icon(Icons.egg), label: "나와 계란"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
      );
  }
}

