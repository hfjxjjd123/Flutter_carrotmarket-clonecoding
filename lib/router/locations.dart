import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
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
  List<Pattern> get pathBlueprints => ["/"];
}
class UploadLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return[
      ...HomeLocation().buildPages(context,state),
      if(state.pathBlueprintSegments.contains('upload'))
        BeamPage(child: Scaffold(
        body: Container(color: Colors.blue,),
        appBar: AppBar(title: Text("올리고 싶은 물건을 추가하세요"),)
      ), key: ValueKey("upload")),
    ];
  }

  @override
  List get pathBlueprints => ["/upload"];

}
