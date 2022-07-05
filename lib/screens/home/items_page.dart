import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/data/address_model.dart';
import 'package:flutter_practice1/data/items_model.dart';
import 'package:flutter_practice1/repo/item_service.dart';
import 'package:flutter_practice1/repo/user_service.dart';
import 'package:flutter_practice1/router/locations.dart';
import 'package:flutter_practice1/states/item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../consts/consts.dart';
import '../../utils/logger.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints){
      Size size = MediaQuery.of(context).size;
      final imageSize = size.width/4;

      return FutureBuilder<List<ItemsModel>>(
        future: ItemService().getItems(),
          builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: (snapshot.hasData)
                ?_listView(imageSize, snapshot.data)
                :_shimmerView(imageSize),
          );
      });

    },
    );

  }

  ListView _listView(double imageSize,List<ItemsModel>? items) {
    int counter = 0;
    if(items == null)   items = [];
    return ListView.separated(
        padding: EdgeInsets.all(default_padding),
        itemCount: items.length,
        separatorBuilder: (context, index){
          return Divider(
            height: default_padding*1.5,
            thickness: 1,
            color: Colors.grey[300],
          );
        },

        itemBuilder: (context, index){
          ItemsModel item = items![index];
          return InkWell(
            onTap: (){
              context.beamToNamed('/$LOCA_ITEM/:${item.itemKey}');
            },
            child: SizedBox(
              height: imageSize,
              child: Row(
                children: [
                  SizedBox(
                    width: imageSize, height: imageSize,
                    child: ExtendedImage.network(
                      item.imageDownloadUrls[0],
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  SizedBox(width: small_padding,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                        Text("12일전", style: Theme.of(context).textTheme.subtitle2),
                        Text(item.price.toString()+"원"),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 18,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: [
                                    Icon(Icons.chat, color: Colors.grey[700],),
                                    Text('23',style: TextStyle(color: Colors.grey[700]),),
                                    Icon(Icons.heart_broken,color: Colors.grey[700],),
                                    Text('93',style: TextStyle(color: Colors.grey[700]),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  Widget _shimmerView(double imageSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,

      child: ListView.separated(
          padding: EdgeInsets.all(default_padding),
          itemCount: 6,
          separatorBuilder: (context, index){
            return Divider(
              height: default_padding*1.5,
              thickness: 1,
              color: Colors.grey[300],
            );
          },

          itemBuilder: (context, index){
            return SizedBox(
              height: imageSize,
              child: Row(
                children: [
                  Container(
                    width: imageSize, height: imageSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: small_padding,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: imageSize*1.5,height: imageSize*0.2, decoration: BoxDecoration(color: Colors.white),),
                        SizedBox(height: small_padding*0.5,),
                        Container(width: imageSize*0.5,height: imageSize*0.2, decoration: BoxDecoration(color: Colors.white),),
                        SizedBox(height: small_padding*0.5,),
                        Container(width: imageSize,height: imageSize*0.2, decoration: BoxDecoration(color: Colors.white),),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 18,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: [
                                    Container(width:18*2, height:18, color: Colors.white,),
                                    Container(width: small_padding*0.5,),
                                    Container(width:18*2, height:18, color: Colors.white,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
