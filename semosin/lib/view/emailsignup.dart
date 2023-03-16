import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:semosin/view/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  /// 날짜 :2023.03.15
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 :  Email Sign up 화면

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  late TextEditingController emailTextController;
  late TextEditingController pwTextController;
  late TextEditingController checkpwTextController;
  late String emailText;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    pwTextController = TextEditingController();
    checkpwTextController = TextEditingController();
    emailText = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // 없음
      body: Center(
        child: Column(
          children: [
            // 신발 이미지
            // 타이틀 Sign Up
            // 이메일 tf
            textFormField(emailTextController, null, false,
                TextInputType.emailAddress, false, 'email', null, null),
            // 비밀번호 tf
            textFormField(pwTextController, null, false, TextInputType.text,
                true, 'password', null, null),
            // 비밀번호 확인 tf
            textFormField(checkpwTextController, null, false,
                TextInputType.text, true, 'check password', null, null),

            Row(
              children: [
                sendEmailButton(),
                nextButton(),
                // 이메일 인증 버튼 : 1. sendEmailAPI()
                //                2. email인증 버튼으로 바뀜
                // 회원가입 버튼 : fireAuthEmailAuth check() 후 SignUp page 이동
              ],
            )
          ],
        ),
      ),
    );
  }
//--------Function --------------------------------------
  // child widget

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : sign up에 사용되는 textField
  /// 비고 : obscureText를 추가함(상혁)
  textFormField(controller, focusNode, readOnly, keyboardType, obscureText,
      label, inputFormatters, onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(label),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
        inputFormatters: inputFormatters,
        onChanged: (value) {
          onChanged;
        },
      ),
    );
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : emailSignup 함수 호출을 포함한 버튼
  /// 비고 :
  sendEmailButton() {
    return emailTextController.text.trim().isNotEmpty &
            pwTextController.text.trim().isNotEmpty &
            checkpwTextController.text.trim().isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 180,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  emailSignup(
                      email: emailTextController.text,
                      password: pwTextController.text);
                  // insertUserInfo();
                },
                child: const Text(
                  'Send Auth E-mail',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 180,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  emailSignup(
                      email: emailTextController.text,
                      password: pwTextController.text);
                  // insertUserInfo();
                },
                child: const Text(
                  'Send Auth E-mail again',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 이메일 인증 확인후 회원등록페이지 호출을 포함한 버튼
  /// 비고 :
  nextButton() {
    return //(!user!.emailVerified)
        emailTextController.text.trim().isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 180,
                  height: 58,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      emailText = emailTextController.text;
                      _setEmailSharedPreferences();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signup(),
                        ),
                      );
                    },
                    child: const Text(
                      'Next Page',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 180,
                  height: 58,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      emailText = emailTextController.text;
                      _setEmailSharedPreferences();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signup(),
                        ),
                      );
                    },
                    child: const Text(
                      'Next Page',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : SharedPreferences에 email 값 입력하는 함수
  /// 비고 :
  _setEmailSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailText);
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : emailSignup을 위해서 FireAuth에 계정생성하고 인증메일을 요청하는 함수
  /// 비고 :

  Future<String> emailSignup(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(email);
      print(password);
      user = userCredential.user!;

      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();
        print("sendEmail");
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("The account already exists for that email");

        return "already";
      } else {
        print("fail");
        return "fail";
      }
    }
  }
}
