import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/router/locations.dart';
import 'package:flutter_practice1/screens/sign_up_screen.dart';
import 'package:flutter_practice1/screens/splash_screen.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:flutter_practice1/utils/logger.dart';
import 'package:provider/provider.dart';

bool login = false;



void main(){
  Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _splashLoadingWidget(snapshot));
      }
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if(snapshot.hasError){
      print('error occur while loading');
      return Text("error occur");
    } else if(snapshot.connectionState == ConnectionState.done){
      return EggApp();
    } else {
      return SplashScreen();
    }
  }
}

class EggApp extends StatelessWidget {
  EggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) { return UserProvider(); },
      child: MaterialApp.router(
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            primary: Colors.white,
            minimumSize: Size(39, 39),
          )),
          fontFamily: "NanumGothic",
          hintColor: Colors.grey,
          primarySwatch: Colors.deepOrange,
          textTheme: TextTheme(
            headline3: TextStyle(fontFamily: "SSantokki"),
            subtitle1: TextStyle(fontSize: 15),
            subtitle2: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 2,
            titleTextStyle: TextStyle(color: Colors.black87,fontFamily: "NanumGothic"),
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}

BeamerDelegate _routerDelegate = BeamerDelegate(
  guards: [BeamGuard(
    pathBlueprints: [...HomeLocation().pathBlueprints, ...UploadLocation().pathBlueprints, ...ItemLocation().pathBlueprints],
    check: (context, location) {
      return (Provider.of<UserProvider>(context, listen: true).user != null);

    },
    showPage: BeamPage(child: SignUpScreen()),
  )],
  locationBuilder: BeamerLocationBuilder(
      beamLocations: [HomeLocation(),UploadLocation(),ItemLocation()]),
);


