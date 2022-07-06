import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice1/data/items_model.dart';
import 'package:flutter_practice1/utils/logger.dart';

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
    logger.d(itemsModel.toString());
    return itemsModel;
  }


  Future<List<ItemsModel>> getItems() async {
    CollectionReference<Map<String,dynamic>> collectionReference =  FirebaseFirestore.instance.collection(COLLECTION_ITEM);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference.get();

    List<ItemsModel> items = [];

    for(int i=0; i<snapshots.size ; i++){
      ItemsModel itemsModel = ItemsModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemsModel);
    }

    return items;
  }
}