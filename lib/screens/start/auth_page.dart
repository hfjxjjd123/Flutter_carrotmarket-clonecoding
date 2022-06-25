import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text('전화번호로 로그인', style: Theme.of(context).appBarTheme.titleTextStyle,),
          ),
          body: Padding(
            padding: EdgeInsets.all(default_padding),
            child: Column(
              children: [
                Row(
                  children: [
                    ExtendedImage.asset("assets/images/padlock.png", width: size.width*0.13, height: size.width*0.13,),
                    SizedBox(width: 12,),
                    Text("계란마켓은 전화번호로 가입해요.\n번호는 안전하게 저장되며 어디에도 공개되지 않아요")
                  ],
                ),
                SizedBox(height: 16,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "전화번호: 010-0000-0000",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
