import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../consts/consts.dart';

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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Form(
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
                            onPressed: (){
                            },
                            child: Text("인증번호 인증",),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
