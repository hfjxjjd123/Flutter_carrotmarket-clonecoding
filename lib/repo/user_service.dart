import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice1/consts/keys.dart';
import 'package:flutter_practice1/data/user_model.dart';

class UserService{
  static final UserService _userService = UserService._internal();
  factory UserService()=>_userService;
  UserService._internal();
  
  Future createNewUser(Map<String, dynamic> json, String userkey) async{
    
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userkey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    if(!documentSnapshot.exists){
      await documentReference.set(json);  
    }
    
  }

  Future<UserModel> getUserModel(String userkey)async{
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userkey);
    final DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await documentReference.get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }

}