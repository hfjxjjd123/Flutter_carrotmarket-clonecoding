
import 'package:flutter/material.dart';
import 'package:flutter_practice1/data/address_model2.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';

class InputTitle extends StatelessWidget {
  const InputTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(18),
        hintText: "글 제목",
        enabledBorder: InputBorder.none,
      ),
    );
  }
}