import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practice1/screens/sign_up_screen.dart';
import 'package:flutter_practice1/screens/home_screen.dart';
import 'package:flutter_practice1/screens/upload/upload_screen.dart';
import 'package:flutter_practice1/states/item_notifier.dart';
import 'package:provider/provider.dart';
import '../screens/upload/upload_category.dart';
import '../states/category_notifier.dart';

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
  Widget builder(BuildContext context, Widget navigator) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context)=>ItemNotifier()),
        ChangeNotifierProvider.value(value: categoryNotifier),
      ],
      child: super.builder(context, navigator),
    );
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return[
      ...HomeLocation().buildPages(context,state),
      if(state.pathBlueprintSegments.contains('upload'))
        BeamPage(child: UploadScreen(), key: ValueKey("upload")),
      if(state.pathBlueprintSegments.contains('select_category'))
        BeamPage(child: UploadCategory(), key: ValueKey("select_category")),
    ];
  }

  @override
  List get pathBlueprints => ["/upload","/upload/select_category"];

}
