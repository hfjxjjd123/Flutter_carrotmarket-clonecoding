import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice1/data/items_model.dart';

import '../consts/keys.dart';

class ItemService{
  static final ItemService _itemService = ItemService._internal();
  factory ItemService()=>_itemService;
  ItemService._internal();

  Future createNewItem(Map<String, dynamic> json, String itemKey) async{

    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection(COLLECTION_ITEM).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }

  }

  Future<ItemsModel> getItemModel(String itemKey)async{
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection(COLLECTION_ITEM).doc(itemKey);
    final DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await documentReference.get();
    ItemsModel itemsModel = ItemsModel.fromSnapshot(documentSnapshot);
    return itemsModel;
  }

}