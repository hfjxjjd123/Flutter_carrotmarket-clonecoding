import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:provider/provider.dart';
import '../../consts/consts.dart';
import '../../utils/logger.dart';

TextEditingController _phoneController = TextEditingController(
  text: "010"
);
TextEditingController _codeController = TextEditingController(
);

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

enum VerificationState{
  none,
  codeSent,
  verifying,
  verified
}

VerificationState _verificationState = VerificationState.none;

double authBoxHeight(VerificationState _verificationState){
  switch(_verificationState){

    case VerificationState.none:
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
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void verification() async {
    setState((){_verificationState = VerificationState.verifying;});
    await Future.delayed(Duration(seconds: 2));
    setState((){_verificationState = VerificationState.verified;});
    context.read<UserProvider>().setUserAuth(true);
    logger.d(context.read<UserProvider>().userState);
    ///참고 - user_provider.dart 파일의 Provider 참고
    ///에러포인트: logger.d(context.read<UserProvider>().userState); 로 true값이 호출되었음.
    ///따라서 setUserAuth(true)로 Provider 안에 있는 변수 userState가 false->true 로 바뀌었음을 알 수 있음
    ///setUserAuth(true) 메소드로 Provider의 변수가 바뀌었으므로 setUserAuth메소드가 실행됐음을 알 수 있음
    ///setUserAuth메소드의 _userLoggedIn = authState;부분이 실행됐으니
    ///그 다음줄인 notifyListeners(); 또한 호출되었음 debugging 과정에서도 저 코드를 거친다는 것을 확인
    ///=> notifyListeners();를 쓰는 부분까지는 문제가 없다고 판단.
  }

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
                        Text("계란마켓은 전화번호로 가입해요.\n번호는 안전하게 저장되며 어디에도 공개되지 않아요")
                      ],
                    ),
                    SizedBox(height: 16,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [MaskedInputFormatter("010-0000-0000")],
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
                          onPressed: (){
                            if(_formKey.currentState != null){
                              bool passed = _formKey.currentState!.validate();
                              if(passed){
                                setState((){
                                  _verificationState = VerificationState.codeSent;
                                });

                              }
                            }

                          },
                          child: Text("인증문자 받기", style: TextStyle(color: Colors.white),),
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
}
