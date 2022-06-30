import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/main.dart';
import 'package:flutter_practice1/widgets/upload_screen/dividor.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';
import '../../widgets/upload_screen/input_title.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
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
              dense: true,
              title: Text("선택", style: TextStyle(fontSize: 14),),
              trailing: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: (){},
              ),
            ),
          ),
          Dividor(),



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


