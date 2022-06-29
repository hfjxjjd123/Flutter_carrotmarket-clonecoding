import 'package:flutter/material.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index){
      return Row(
        children: [
          Image.asset(''),
          Column(
            children: [
              Container(),
              Container(),
              Container(),
              Container(),
              Row(
                children: [

                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
