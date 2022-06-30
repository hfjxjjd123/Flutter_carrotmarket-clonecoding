import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/states/category_notifier.dart';
import 'package:provider/provider.dart';

class UploadCategory extends StatelessWidget {
  const UploadCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("카테고리 설정"),),
      body: ListView.separated(
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                context.read<CategoryNotifier>().setKorSelected(categoryNotifier.categoryKor.values.elementAt(index));
                context.beamBack();
              },
              title: Text(context.read<CategoryNotifier>().categoryKor.values.elementAt(index),
              style: TextStyle(color: (context.read<CategoryNotifier>().categoryKor.values.elementAt(index)==context.read<CategoryNotifier>().categorySelectedKor)?Theme.of(context).primaryColor:Colors.black87),),
            );
          },
          separatorBuilder: (context, index){
            return Divider(
              height: 10,
              color: Colors.black45,
              thickness: 1.5,
            );
          },
          itemCount: context.read<CategoryNotifier>().categoryKor.length),
    );
  }
}
