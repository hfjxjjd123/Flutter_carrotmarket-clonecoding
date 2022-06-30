import 'package:flutter/material.dart';

class Dividor extends StatelessWidget {
  const Dividor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 1,
      indent: 18, endIndent: 18,
      color: Colors.grey[400],
    );
  }
}
