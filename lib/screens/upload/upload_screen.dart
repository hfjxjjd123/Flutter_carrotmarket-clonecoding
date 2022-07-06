import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_practice1/data/items_model.dart';
import 'package:flutter_practice1/data/user_model.dart';
import 'package:flutter_practice1/main.dart';
import 'package:flutter_practice1/repo/item_service.dart';
import 'package:flutter_practice1/repo/upload_image_storage.dart';
import 'package:flutter_practice1/router/locations.dart';
import 'package:flutter_practice1/states/category_notifier.dart';
import 'package:flutter_practice1/states/item_notifier.dart';
import 'package:flutter_practice1/widgets/upload_screen/dividor.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import '../../states/user_provider.dart';
import '../../utils/logger.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {


  bool _pricePrefered = false;
  bool _isUploading = false;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    void attemptCreateItem() async{
      if(FirebaseAuth.instance.currentUser == null ) return;
      _isUploading = true;
      setState((){});

      final String userkey = FirebaseAuth.instance.currentUser!.uid;
      final String itemKey = ItemsModel.generateItemKey(userkey);

      List<Uint8List> images =  context.read<ItemNotifier>().images;

      UserProvider userProvider = context.read<UserProvider>();

      String category = context.read<CategoryNotifier>().categorySelectedEng;

      List<String> downloadUrls = await UploadImageStorage.uploadImageGetURLS(images, itemKey);

      final num? price = num.tryParse(_priceController.text.replaceAll(',', '').replaceFirst('원', ''));

      ItemsModel itemsModel = ItemsModel(
        itemKey: itemKey,
        userkey: userkey,
        imageDownloadUrls: downloadUrls,
        title: _titleController.text,
        category: category,
        price: price??0,
        negotiable: _pricePrefered, detail: _detailController.text,
        address: userProvider.userModel!.address, geoFirePoint: userProvider.userModel!.geoFirePoint,
        createdDate: DateTime.now().toUtc(),
      );

      await ItemService().createNewItem(itemsModel, itemKey, userkey);
      context.beamBack();
    }

    return Provider<CategoryNotifier>.value(
        value: categoryNotifier,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      Size _size = MediaQuery.of(context).size;
      return IgnorePointer(
        ignoring: _isUploading,
        child: Scaffold(
          body: ListView(
            children: [
              ImageListview(),
              Dividor(),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  hintText: "글 제목",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              Dividor(),
              Padding(
                padding: EdgeInsets.all(3),
                child: ListTile(
                  onTap: (){
                    context.beamToNamed("/$LOCA_UPLOAD/$LOCA_SELECT_CATEGORY");
                  },
                  dense: true,
                  title: Text(
                    context.watch<CategoryNotifier>().categorySelectedKor,
                    style: TextStyle(fontSize: 14),),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              Dividor(),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: TextFormField(
                          inputFormatters: [MoneyInputFormatter(mantissaLength: 0, trailingSymbol: "원")],
                          onChanged: (value){
                            if(value == '0원' || value=='0'){
                              _priceController.clear();
                            }
                            setState((){});
                          },
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "얼마에 파시겠어요?",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: ImageIcon(
                              ExtendedAssetImageProvider(
                                  "assets/images/won1.png"
                              ),
                              color: (_priceController.text.isEmpty)
                                  ?Colors.black38
                                  :Colors.black87,
                            ),
                            prefixIconConstraints: BoxConstraints(maxWidth: 20),
                          ),
                        ),
                      )
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      primary: Theme.of(context).primaryColor,
                    ),
                    label: Text("가격제안 받기", style: TextStyle(color: (_pricePrefered)?Theme.of(context).primaryColor:Colors.black38),),
                    icon: Icon(
                        (_pricePrefered)?Icons.check_circle:Icons.check_circle_outline,
                        color: (_pricePrefered)?Theme.of(context).primaryColor:Colors.black38),
                    onPressed: () {
                      setState((){
                        _pricePrefered = !_pricePrefered;
                      });
                    },
                  )
                ],
              ),
              Dividor(),
              TextFormField(
                maxLines: 12,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                controller: _detailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  hintText: "내용을 입력하세요",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),



            ],
          ),
          appBar: AppBar(
            bottom: PreferredSize(
              child: (_isUploading)?LinearProgressIndicator(minHeight: 2,):Container(), preferredSize: Size(_size.width ,2 ),
            ),
            centerTitle: true,
            title: Text("중고거래 글쓰기", style: Theme.of(context).textTheme.subtitle1,),
            elevation: 4,
            leading: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.white, primary:Colors.black54),
              onPressed: () { context.beamBack(); },
              child: Text('닫기', style: Theme.of(context).textTheme.subtitle2,),

            ),
            actions: [
              TextButton(
                child: Text('완료', style: Theme.of(context).textTheme.subtitle2,),
                style: TextButton.styleFrom(backgroundColor: Colors.white, primary: Colors.black54),
                onPressed: (){
                  if(
                  context.read<ItemNotifier>().images!=null
                  && _titleController.text.isNotEmpty
                  && _priceController.text.isNotEmpty
                  && _detailController.text.isNotEmpty
                  ){
                    attemptCreateItem();
                  }

                },

              ),
            ],
          ),
        ),
      );
    }));
  }

}


