import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/consts/consts.dart';
import 'package:flutter_practice1/data/items_model.dart';

class SimilarItem extends StatelessWidget {
  final ItemsModel _itemsModel;
  const SimilarItem(this._itemsModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        AspectRatio(
            aspectRatio: 5/4,
          child: ExtendedImage.network(
            _itemsModel.imageDownloadUrls[0],
            fit: BoxFit.cover,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(
          _itemsModel.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(_itemsModel.price.toString()+"원",
          style: Theme.of(context).textTheme.subtitle2,),
        Container(height: small_padding/2,),
      ],
    );
  }
}
