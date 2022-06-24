import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';


final portionOfPosSize = 0.1;
class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imageWidth = size.width - 24;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("계란마켓", style: Theme
                    .of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Theme
                    .of(context)
                    .primaryColor),),
                Stack(
                  children: [
                    SizedBox(
                        width: imageWidth, height: imageWidth,
                        child: ExtendedImage.asset("assets/images/carrot_intro.png",)
                    ),
                    Positioned(
                        left: imageWidth*(1-portionOfPosSize)/2,
                        width: imageWidth*portionOfPosSize,
                        top: imageWidth*(1-portionOfPosSize)/2,
                        height: imageWidth*portionOfPosSize,
                        child: ExtendedImage.asset(
                          "assets/images/carrot_intro_pos.png",)
                    )
                  ],
                ),
                Text("우리동네 중고 직거래 계란마켓",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                Text("계란마켓은 동네 직거래 마켓이에요\n 지역을 설정하고 시작해보세요",),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                        onPressed: toStart,
                        child: Text("내 동네 설정하고 시작하기",
                          style: TextStyle(color: Colors.white),),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

void toStart(){
  logger.d("Clicked");
}