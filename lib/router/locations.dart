import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practice1/screens/item/item_detail_screen.dart';
import 'package:flutter_practice1/screens/sign_up_screen.dart';
import 'package:flutter_practice1/screens/home_screen.dart';
import 'package:flutter_practice1/screens/upload/upload_screen.dart';
import 'package:flutter_practice1/states/item_notifier.dart';
import 'package:provider/provider.dart';
import '../screens/upload/upload_category.dart';
import '../states/category_notifier.dart';

String LOCA_HOME = 'home';
String LOCA_UPLOAD = 'upload';
String LOCA_SELECT_CATEGORY = 'select_category';
String LOCA_ITEM = 'item';
String LOCA_ITEM_ID = 'item_id';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(context, state) {
    return [
      BeamPage(child: HomeScreen(),key: ValueKey(LOCA_HOME))
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
      if(state.pathBlueprintSegments.contains(LOCA_UPLOAD))
        BeamPage(child: UploadScreen(), key: ValueKey(LOCA_UPLOAD)),
      if(state.pathBlueprintSegments.contains(LOCA_SELECT_CATEGORY))
        BeamPage(child: UploadCategory(), key: ValueKey(LOCA_SELECT_CATEGORY)),
    ];
  }

  @override
  List get pathBlueprints => ["/$LOCA_UPLOAD","/$LOCA_UPLOAD/$LOCA_SELECT_CATEGORY"];

}

class ItemLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathParameters.containsKey(LOCA_ITEM_ID))
        BeamPage(child: ItemDetailScreen(state.pathParameters[LOCA_ITEM_ID] ?? ""), key: ValueKey(LOCA_ITEM_ID)),
    ];
  }

  @override
  List get pathBlueprints => ["/$LOCA_ITEM/:$LOCA_ITEM_ID"];

}