import 'package:beamer/beamer.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1),()=>100),
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
  EggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        logger.d("Rebuilding..."); //rebuilding을 안하는데요?
        return UserProvider(); },
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
    pathBlueprints: ["/"],
    check: (context, location) {
      logger.d("HowMany? 현재상태: ${Provider.of<UserProvider>(context, listen: true).userState}");
      ///에러포인트: provider에서 notifyListeners()를 실행했음
      ///하지만 앱을 실행했을 때 logger.d("HowMany?");에서 HowMany가 한 번만 호출됨
      ///check 부분이 provider가 바뀌었을때 다시 실행돼야 하는데 그러지 않았음을 알 수 있음
      ///Provider를 통한 위젯 리빌딩 과정이 일어나지 않았음을 알 수 있음
      ///=>context.watch<UserProvider>().userState 부분에서 .watch()가 기능수행을 안해서
      ///MaterialApp.router(Provider를 상속받은 상위위젯)가 리빌딩되지 않은게 원인이라고
      ///리빌딩이 왜 안되는 거냐고
      return Provider.of<UserProvider>(context, listen: true).userState;

    },
    showPage: BeamPage(child: SignUpScreen()),
  )],
  locationBuilder: BeamerLocationBuilder(
      beamLocations: [HomeLocation()]),
);


