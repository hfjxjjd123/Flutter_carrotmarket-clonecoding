import 'package:flutter/material.dart';
import 'package:flutter_practice1/splash_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2),()=>100),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return EggApp();
        } else if(snapshot.hasError){
          return Text("Error!");
        } else {
          return SplashScreen();
        }
      }
    );
  }
}

class EggApp extends StatelessWidget {
  const EggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

