import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practice1/screens/sign_up_screen.dart';
import 'package:flutter_practice1/screens/home_screen.dart';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(context, state) {
    return [
      BeamPage(child: HomeScreen(),key: ValueKey("home"))
    ];
  }

  @override
  List<Pattern> get pathPatterns => ["/"];
}

class AuthLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    return[
      BeamPage(child: SignUpScreen(), key: ValueKey("auth"))
    ];
  }
  @override
  List<Pattern> get pathPatterns => ["/auth"];

}
