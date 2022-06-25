import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25,),
                // prefixIconConstraints: BoxConstraints(),
                hintText: "주소를 입력하세요",
                hintStyle: TextStyle(color:Theme.of(context).hintColor),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.navigation, color: Colors.white, size: 18,),
                onPressed: (){

                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                label: Text("현재위치로 찾기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text("address $index"),
                      subtitle: Text("address $index"),

                    );
                  }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
