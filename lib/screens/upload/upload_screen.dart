import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_practice1/main.dart';
import 'package:flutter_practice1/states/category_notifier.dart';
import 'package:flutter_practice1/widgets/upload_screen/dividor.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';
import 'package:provider/provider.dart';
import '../../widgets/upload_screen/input_title.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  bool _pricePrefered = false;
  TextEditingController _priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ImageListview(),
          Dividor(),
          InputTitle(),
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
        centerTitle: true,
        title: Text("중고거래 글쓰기", style: Theme.of(context).textTheme.subtitle1,),
        elevation: 4,
        leading: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () { context.beamBack(); },
          child: Text('닫기', style: Theme.of(context).textTheme.subtitle2,),

        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () { context.beamBack(); },
            child: Text('완료', style: Theme.of(context).textTheme.subtitle2,),
          ),
        ],
      ),
    );
  }

}


