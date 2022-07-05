import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_practice1/data/items_model.dart';

import '../utils/logger.dart';

class UploadImageStorage{

  static Future<List<String>> uploadImageGetURLS(List<Uint8List> selectedImages, String itemKey) async{


      var metaData = SettableMetadata(contentType: 'image/jpeg');

      List<String> downloadUrls = [];

        for(int i=0; i<selectedImages.length; i++){
          Reference ref = FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
          if(selectedImages.isNotEmpty) await ref.putData(selectedImages[i], metaData).catchError((onError){
            logger.e(onError.toString());
          });
          downloadUrls.add(await ref.getDownloadURL());
        }
        return downloadUrls;

    // List<String> imageUrls = [];
    // String itemKeyForUploading = itemKey;
    // if(selectedImages.isNotEmpty){
    //   for(int i=0;i<selectedImages.length;i++){
    //     Reference ref = FirebaseStorage.instance.ref('images/$itemKeyForUploading/$i.jpg');
    //     await ref.putData(selectedImages[i]).catchError((onError){
    //       logger.d(onError.toString());
    //     });
    //     imageUrls.add(await ref.getDownloadURL());
    //   }
    //   return imageUrls;
    // } else return [];
  }

}