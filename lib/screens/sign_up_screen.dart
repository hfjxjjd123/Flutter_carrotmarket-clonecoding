import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/screens/start/address_page.dart';
import 'package:flutter_practice1/screens/start/auth_page.dart';
import 'package:flutter_practice1/screens/start/intro_page.dart';
import 'package:flutter_practice1/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'start/address_service.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  PageController _authPageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _authPageController,
      child: Scaffold(
        body: PageView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _authPageController,
          children:[
          IntroPage(),
          AddressPage(),
          AuthPage(),
        ], ),
      ),
    );
  }
}
