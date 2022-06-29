import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier{
  bool _userLoggedIn =false;

  UserProvider(){
    initUser();
  }

  User? _user;

  void initUser(){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  void setNewUser(User? user){

  }

}