import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/states/item_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageListview extends StatefulWidget {
  ImageListview({Key? key}) : super(key: key);
  @override
  State<ImageListview> createState() => _ImageListviewState();
}

List<Uint8List> _selectedImages=[];

class _ImageListviewState extends State<ImageListview> {
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        ItemNotifier itemNotifier = context.watch<ItemNotifier>();


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
                  child: InkWell(
                    onTap: ()async{
                      final ImagePicker _picker = ImagePicker();
                      final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 20);
                      if (images != null && images.isNotEmpty) {
                        await context.read<ItemNotifier>().setNewImages(images);
        }
                    },
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
              ),
              ...List.generate(itemNotifier.images.length, (index) =>
                  Stack(
                    children: [
                      Padding(padding: EdgeInsets.only(top: insetsSize, bottom: insetsSize, right: insetsSize),
                        child: ExtendedImage.memory(
                          itemNotifier.images[index],
                          fit: BoxFit.cover,
                          width: innerBoxSize, height: innerBoxSize,
                          shape:BoxShape.rectangle, borderRadius: BorderRadius.circular(15),
                          loadStateChanged: (state){
                            switch(state.extendedImageLoadState){

                              case LoadState.loading:
                                return Padding(
                                  padding: EdgeInsets.all(innerBoxSize/3),
                                  child: CircularProgressIndicator(),
                                );
                              case LoadState.completed:
                                return null;
                              case LoadState.failed:
                                return Icon(Icons.cancel);
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: boxSize/30, top: boxSize/30,
                        child: IconButton(
                            onPressed: (){
                              itemNotifier.removeImage(index);
                            },
                            icon: Icon(Icons.remove_circle),
                          iconSize: boxSize/5,
                        ),
                      )
                    ],
                  ),),


            ],
          ),
        );
      },
    );
  }
}

class ImageGetter{
  static List<Uint8List>? getSelectedImages(){
    return _selectedImages;
  }
}