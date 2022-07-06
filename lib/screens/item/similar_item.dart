import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/consts/consts.dart';

class SimilarItem extends StatelessWidget {
  const SimilarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        AspectRatio(
            aspectRatio: 5/4,
          child: ExtendedImage.network(
            'https://picsum.photos/100',
            fit: BoxFit.cover,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(
          '저쩔냉장고',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.subtitle1,
        ),
        Text('400,000원',
          style: Theme.of(context).textTheme.subtitle2,),
        Container(height: small_padding/2,),
      ],
    );
  }
}
