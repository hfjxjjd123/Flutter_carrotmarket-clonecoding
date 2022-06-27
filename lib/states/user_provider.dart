import 'package:flutter/widgets.dart';

// class UserPro extends ChangeNotifier{
//   bool _userLoggedIn =false;
//
//   void setUserAuth(bool authState){
//     _userLoggedIn = authState;
//     notifyListeners();
//   }
//
//
//   bool get userState => _userLoggedIn;
//
// }
class UserPro extends ChangeNotifier{
  bool _userLoggedIn =false;

  void setUserAuth(bool authState){
    _userLoggedIn = authState;
    notifyListeners();
  }


  bool get userState => _userLoggedIn;

}