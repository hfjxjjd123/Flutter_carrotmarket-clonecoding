import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/data/items_model.dart';
import 'package:flutter_practice1/repo/item_service.dart';
import 'package:flutter_practice1/widgets/upload_screen/image_listview.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';

import '../repo/upload_image_storage.dart';

ItemNotifier itemNotifier = ItemNotifier();

class ItemNotifier extends ChangeNotifier{
  List<Uint8List> _images = [];

  Future setNewImages(List<XFile>? newImages) async {
      for (int index = 0; index < newImages!.length; index++) {
        _images.add(await newImages[index].readAsBytes());
      }
    notifyListeners();
  }
  List<Uint8List> get images => _images;

  void removeImage(int index){
    if(_images.isNotEmpty && _images.length>=index){
      _images.removeAt(index);
    }
    notifyListeners();
  }
}