import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(12.0),
        child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25,),
                // prefixIconConstraints: BoxConstraints(),
                hintText: "주소를 입력하세요",
                hintStyle: TextStyle(color:Theme.of(context).hintColor),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
