import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageListview extends StatelessWidget {
  const ImageListview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = MediaQuery.of(context).size;
        final double boxSize = size.width*0.4;
        final double insetsSize = size.width*0.05;
        final double innerBoxSize = boxSize-2*insetsSize;
        return SizedBox(
          height: boxSize,
          width: size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: boxSize,height: boxSize,
                child: Padding(
                  padding: EdgeInsets.all(insetsSize),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.grey[600],),
                        Text("0/10",style: TextStyle(color: Colors.grey[600]),),
                      ],
                    ),
                    width: innerBoxSize, height: innerBoxSize,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[600]!),
                      borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              ),
              ...List.generate(10, (index) =>
                  Stack(
                    children: [
                      Padding(padding: EdgeInsets.only(top: insetsSize, bottom: insetsSize, right: insetsSize),
                        child: ExtendedImage.network("https://picsum.photos/200",
                      width: innerBoxSize, height: innerBoxSize,
                      shape:BoxShape.rectangle, borderRadius: BorderRadius.circular(15),),
                      ),
                      Positioned(
                        child: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.remove_circle),
                          iconSize: boxSize/5,
                        ),
                        right: boxSize/30, top: boxSize/30,
                      )
                    ],
                  ),),


            ],
          ),
        );
      },
    ); ;
  }
}
