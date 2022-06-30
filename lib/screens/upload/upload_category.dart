import 'package:flutter/material.dart';
const List<String> categories = [
  '선택',
  '가구',
  '전자기기',
  '유아동',
  '스포츠',
  '메이크업',
  '남성',
  '여성'
];

class UploadCategory extends StatelessWidget {
  const UploadCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("카테고리 설정"),),
      body: ListView.separated(
          itemBuilder: (context, index){
            return ListTile(
              title: Text(categories[index]),
            );
          },
          separatorBuilder: (context, index){
            return Divider(
              height: 10,
              color: Colors.black45,
              thickness: 1.5,
            );
          },
          itemCount: categories.length),
    );
  }
}
