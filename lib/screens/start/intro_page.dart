import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("계란마켓"),
        ExtendedImage.asset("assets/images/carrot_intro.png"),
        Text("우리동네 중고 직거래 계란마켓"),
        Text("계란마켓은 동네 직거래 마켓이에요\n 지역을 설정하고 시작해보세요"),
        TextButton(
            onPressed: toStart,
            child: Text("내 동네 설정하고 시작하기", style: TextStyle(color: Colors.white),),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            )
        )
      ],
    );
  }
}

void toStart(){
  logger.d("Clicked");
}