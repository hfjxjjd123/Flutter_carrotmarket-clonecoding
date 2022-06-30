import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  Future firestoreTest() async {
    Map<String, dynamic> data = {'testing':"on testing", 'number':123456};
    FirebaseFirestore.instance.collection("TESTING_COLLECTION").add(data);
  }
}