import 'package:flutter/material.dart';
import 'package:flutter_practice1/main.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void toLogout() {
    setState((){
      context.read<UserProvider>().setUserAuth(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          toLogout();
        }, icon: Icon(Icons.logout))],
      ),
      );
  }
}

