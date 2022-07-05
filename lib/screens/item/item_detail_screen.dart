import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  String itemKey;
  ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child:Text("${widget.itemKey}"),
    );
  }
}
