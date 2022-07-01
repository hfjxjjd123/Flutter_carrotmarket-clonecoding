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
import 'package:flutter_practice1/repo/upload_image_storage.dart';
import 'package:flutter_practice1/states/category_notifier.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:flutter_practice1/widgets/upload_screen/dividor.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';
import 'package:provider/provider.dart';
import '../../utils/logger.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {


  bool _pricePrefered = false;
  TextEditingController _priceController = TextEditingController();
  bool _isUploading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    String userKey = FirebaseAuth.instance.currentUser!.uid;

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
                  context.beamToNamed("/upload/select_category");
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
            child: (_isUploading)?LinearProgressIndicator(minHeight: 2,):Container(), preferredSize: Size(size.width ,2 ),
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
              onPressed: () async{
                _isUploading = true;


                setState((){});
                String itemKey = ItemsModel.generateItemKey(userKey);
                List<String> imageUrls = [];
                UserProvider userProvider = context.read<UserProvider>();
                List<Uint8List> selectedImages = [];
                num? price;
                if(_priceController.text.isNotEmpty){
                  price = num.parse(_priceController.text.replaceAll(',', '').replaceFirst('원', ''));
                } else price = null;
                if(
                (ImageGetter.getSelectedImages()!=null && ImageGetter.getSelectedImages()!.isNotEmpty)
                &&(_titleController.text!=null && _titleController.text.isNotEmpty)
                &&(price!=null)
                &&(_detailController.text!=null && _detailController.text.isNotEmpty)
                ){
                  selectedImages =  ImageGetter.getSelectedImages()!;
                  if(selectedImages.length!=0){
                    imageUrls = await UploadImageStorage.uploadImageGetURLS(selectedImages, userKey);
                    logger.d("done!- ${imageUrls.toString()}, $price");
                  }
                }
                _isUploading =false;
                setState((){});
                // context.beamBack(); Error! NO Provider

                // ItemsModel(
                //     itemKey: itemKey,
                //     userKey: userKey,
                //     imageDownloadUrls: imageUrls,
                //     title: _titleController.text,
                //     category: context.read<CategoryNotifier>().categorySelectedEng,
                //     price: price,
                //     negotiable: _pricePrefered,
                //     detail: _detailController.text,
                //     address: userProvider.userModel.address, geoFirePoint: userProvider.userModel.geoFirePoint,
                //     createdDate: DateTime.now().toUtc(),
                // );
              },

            ),
          ],
        ),
      ),
    );
  }

}


