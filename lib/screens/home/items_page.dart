import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      Size size = MediaQuery.of(context).size;
      final imageSize = size.width/4;

      return ListView.separated(
          padding: EdgeInsets.all(default_padding),
          itemCount: 10,
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
                  ExtendedImage.network(
                    'https://picsum.photos/100',
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  SizedBox(width: small_padding,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("work", style: Theme.of(context).textTheme.subtitle1),
                        Text("12일전", style: Theme.of(context).textTheme.subtitle2),
                        Text("3,000원"),
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
            );
          });
    },
    );

  }
}
