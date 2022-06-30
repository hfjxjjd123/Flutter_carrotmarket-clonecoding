import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_practice1/consts/keys.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts/consts.dart';
import '../../main.dart';
import '../../utils/logger.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController _phoneController = TextEditingController(
    text: "010"
);

TextEditingController _codeController = TextEditingController(
);

enum VerificationState{
  none,
  codeSending,
  codeSent,
  verifying,
  verified
}

VerificationState _verificationState = VerificationState.none;

double authBoxHeight(VerificationState _verificationState){
  switch(_verificationState){

    case VerificationState.none:
    case VerificationState.codeSending:
      return 0;
      break;
    case VerificationState.codeSent:
    case VerificationState.verifying:
    case VerificationState.verified:
      return 120;
      break;
  }
}




class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();




}

class _AuthPageState extends State<AuthPage> {
  void verification() async {
    setState(() {
      _verificationState = VerificationState.verifying;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _codeController.text);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
  catch(e){
    logger.e("failed!!");
    SnackBar snackBar = SnackBar(content: Text("입력하신 인증코드가 틀립니다"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }//실패시 갈라치기? 실패 판단?
    setState((){_verificationState = VerificationState.verified;});
  }

  String? _verificationId;
  int? _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return IgnorePointer(
          ignoring: (_verificationState == VerificationState.verifying)?true:false,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text('전화번호로 로그인', style: Theme.of(context).appBarTheme.titleTextStyle,),
              ),
              body: Padding(
                padding: EdgeInsets.all(default_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ExtendedImage.asset("assets/images/padlock.png", width: size.width*0.13, height: size.width*0.13,),
                        SizedBox(width: 12,),
                        Container(
                            width: size.width*0.75,
                            child: Text("계란마켓은 전화번호로 가입해요.\n번호는 안전하게 저장되며 어디에도 공개되지 않아요"))
                      ],
                    ),
                    SizedBox(height: 16,),
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [MaskedInputFormatter("000-0000-0000")],
                          decoration: InputDecoration(
                            hintText: "전화번호: 010-0000-0000",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                          validator: (phoneNumber){
                            if(phoneNumber != null && phoneNumber.length==13){
                              return null;
                            } else{
                              return "올바른 핸드폰 번호를 입력하세요";
                            }
                          },
                        ),
                        TextButton(
                          child: Text((_verificationState!=VerificationState.codeSending)?"인증문자 받기":"인증문자 발송중", style: TextStyle(color: Colors.white),),
                          onPressed: () async {
                            if(_verificationState != VerificationState.codeSending){
                              if(_formKey.currentState != null){
                                bool passed = _formKey.currentState!.validate();
                                if(passed){
                                  String phoneNum = _phoneController.text;
                                  phoneNum.replaceAll(' ', '');
                                  phoneNum.replaceFirst('0', '');
                                  FirebaseAuth auth = FirebaseAuth.instance;

                                  setState((){
                                    _verificationState = VerificationState.codeSending;
                                  });


                                  await auth.verifyPhoneNumber(
                                    phoneNumber: '+82$phoneNum',
                                    verificationCompleted: (PhoneAuthCredential credential) async {

                                      await auth.signInWithCredential(credential);
                                    },
                                    forceResendingToken: _forceResendingToken,
                                    codeAutoRetrievalTimeout: (String verificationId) {  },

                                    codeSent: (String verificationId, int? forceResendingToken) {
                                      setState((){
                                        _verificationState = VerificationState.codeSent;
                                        _forceResendingToken = forceResendingToken;
                                      });
                                      _verificationId = verificationId;
                                    },
                                    verificationFailed: (FirebaseAuthException error) { _verificationState = VerificationState.none; },
                                  );



                                }
                              }
                            }


                          },

                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: (_verificationState==VerificationState.none)? 0:1,
                      child: AnimatedContainer(
                        height: authBoxHeight(_verificationState),
                        duration: Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              // validator: (authCode){
                              //   if(authCode != null && authCode.length==6){
                              //     return null;
                              //   } else{
                              //     return "6자리 인증코드를 입력하세요";
                              //   }
                              // }, validator 가 2개일 때,
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [MaskedInputFormatter("000000")],
                              decoration: InputDecoration(
                                hintText: "6자리",
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                verification();
                              },
                              child: (_verificationState==VerificationState.verifying)?CircularProgressIndicator(color: Colors.white,):Text("인증번호 인증")),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  // _getAddress()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String address = prefs.getString(SHARED_ADDRESS)??"";
  //   double latitude = prefs.getDouble(SHARED_LAT)??0;
  //   double longitude = prefs.getDouble(SHARED_LOG)??0;
  //
  // }
}
