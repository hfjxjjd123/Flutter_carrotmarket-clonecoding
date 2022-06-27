import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Column(
        children: [
          Container(width:100, height:100, child: ExtendedImage.asset("assets/images/egg.png")),
          CircularProgressIndicator(color: Colors.deepOrangeAccent,),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )),
    );
  }
}
