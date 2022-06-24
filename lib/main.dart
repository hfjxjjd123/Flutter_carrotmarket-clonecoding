import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/router/locations.dart';
import 'package:flutter_practice1/screens/auth_screen.dart';
import 'package:flutter_practice1/screens/splash_screen.dart';
import 'package:flutter_practice1/utils/logger.dart';

final _routerDelegate = BeamerDelegate(
    guards: [BeamGuard(
      pathPatterns: ["/"],
      check: (context, location) {
        return false;
        },
      beamToNamed: (origin, target)=>"/auth",
    )],
  locationBuilder: BeamerLocationBuilder(
      beamLocations: [HomeLocation(),AuthLocation()]),
);

void main(){

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2),()=>100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _splashLoadingWidget(snapshot));
      }
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if(snapshot.hasData){
      return EggApp();
    } else if(snapshot.hasError){
      return const Text("Error!");
    } else {
      return SplashScreen();
    }
  }
}

class EggApp extends StatelessWidget {
  const EggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}

