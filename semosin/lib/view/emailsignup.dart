import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semosin/view/signup.dart';
import 'package:semosin/view_model/signup_view_model.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  late TextEditingController emailTextController;
  late TextEditingController pwTextController;
  late TextEditingController checkpwTextController;
  late String emailText;
  User? user;
  late int resend = 0;

  late bool emailSendStatus = false;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    pwTextController = TextEditingController();
    checkpwTextController = TextEditingController();
    emailText = "";
  }

  //------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.15
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 :  Email Sign up 화면
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(), // 없음
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sendEmailButton(),
                  nextButton(),
                  // 이메일 인증 버튼 : 1. sendEmailAPI()
                  //                2. email인증 버튼으로 바뀜
                  // 회원가입 버튼 : fireAuthEmailAuth check() 후 SignUp page 이동
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // child widget
  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 수정이 : 권순형 , 이영진
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
          setState(() {});
        },
      ),
    );
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 수정이 : 권순형 , 이영진
  /// 내용 : emailSignup 함수 호출을 포함한 버튼
  /// 비고 :
  sendEmailButton() {
    return emailTextController.text.trim().isNotEmpty &
            pwTextController.text.trim().isNotEmpty &
            isValidPassword(pwTextController.text.trim()) &
            isValidEmailFormat(emailTextController.text.trim()) &
            (checkpwTextController.text.trim() ==
                pwTextController.text.trim()) &
            (resend == 0)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  var result = await emailSignup(
                      email: emailTextController.text,
                      password: pwTextController.text);
                  showDialogAboutSend(result, context);
                  if (result == "success") {
                    setState(() {
                      emailSendStatus = true;
                      resend = 60;
                      // 재전송 timer 시작
                      Future.delayed(const Duration(seconds: 60))
                          .then((_) => resend = 0);
                    });
                  }
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
              width: MediaQuery.of(context).size.width * 0.4,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  // 입력된 email이 정규식을 만족하지 않을 때
                  if (!isValidEmailFormat(emailTextController.text.trim())) {
                    showAlertRegEmailDialog();
                    // 입력된 패스워드가 동일하지 않거나 패스워드가 정규식을 만족하지 않을 때
                  } else if ((pwTextController.text.trim() !=
                          checkpwTextController.text.trim()) |
                      (!isValidPassword(pwTextController.text.trim()))) {
                    showAlertRegPassDialog();
                  }
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
          );
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 수정이 : 권순형 , 이영진
  /// 내용 : 이메일 인증 확인후 회원등록페이지 호출을 포함한 버튼
  /// 비고 :
  nextButton() {
    return emailSendStatus
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  // 1. verify 됐는지 체크 하는 함수
                  var result = await _emailVerificationCheck();

                  if (result != null) {
                    // 2. 됐으면 푸쉬
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup(signUpViewModel: result),
                        ));
                  } else {
                    // 3. 안됐으면 다이얼로그
                    showAlertDialog();
                  }
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
              width: MediaQuery.of(context).size.width * 0.4,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {},
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
  //------------------------------------------------------------------------------------

  //------------------------------------------------------------------------------------
  // dialog
  /// 날짜 :2023.03.16
  /// 작성자 : 권순형
  /// 만든이 : 권순형
  /// 내용 : email 전송 버튼 눌렀을 때 뜰 다이얼로그
  /// 비고 :
  showDialogAboutSend(String result, BuildContext context) {
    var title = "";
    var content = "";

    if (result == "success") {
      title = "전송 성공";
      content = "이메일 전송하였습니다.\n확인해서 인증해주세요.";
    } else if (result == "already") {
      title = "전송 실패";
      content = "이미 회원가입이 되어 있는 이메일 입니다.";
    } else {
      title = "전송 실패";
      content = "이메일 전송에 실패하였습니다.\n다시 시도해주세요.";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  /// 날짜 :2023.03.17
  /// 작성자 : 권순형
  /// 만든이 : 권순형
  /// 내용 : email 인증 안받았을 때 뜨는 다이얼로그
  /// 비고 :
  showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("인증 실패"),
          content: const Text("이메일 인증을 안받으셨습니다.\n이메일 인증 후 다시 시도해주세요."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  //------------------------------------------------------------------------------------
  /// 날짜 :2023.03.17
  /// 작성자 : 권순형
  /// 만든이 : 권순형
  /// 수정 : 이상혁
  /// 내용 : 정규식적용되지 않았을 때 다이얼로그
  /// 비고 :
  showAlertRegPassDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("알림"),
          content: const Text("비밀번호는 8자이상 영문 대소문자, 숫자 및 특수문자를 사용해주세요!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  /// 날짜 :2023.03.17
  /// 작성자 : 권순형
  /// 만든이 : 권순형
  /// 수정 : 이상혁
  /// 내용 : 정규식적용되지 않았을 때 다이얼로그
  /// 비고 :
  showAlertRegEmailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("알림"),
          content: const Text("email형식에 맞춰서 입력해주세요!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  //------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------
  // backend
  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 수정이 : 권순형
  /// 내용 : emailSignup을 위해서 FireAuth에 계정생성하고 인증메일을 요청하는 함수
  /// 수정사항 : store에 있는 user인지 아닌지 체크 후 auth에 등록하고 회원가입 안한 회원인지 찾아서 그거 지우고 다시 이메일 보내는 작업
  Future<String> emailSignup(
      {required String email, required String password}) async {
    // already in user
    final checkUser = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();

    if (checkUser.docs.isEmpty) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        user = credential.user!;

        if (!user!.emailVerified) {
          await user!.sendEmailVerification();
          return "success";
        } else {
          await user!.delete();
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          user = credential.user!;

          await user!.sendEmailVerification();
          return "success";
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          user = userCredential.user!;
          await user!.sendEmailVerification();
          return 'success';
        }
        return "fail";
      }
    } else {
      return "already";
    }
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이영진
  /// 만든이 : 이영진
  /// 내용 : 다음 페이지 갈때 이미지 인증 됐는지 확인하기
  /// 비고 :
  Future<SignUpViewModel?> _emailVerificationCheck() async {
    var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, password: pwTextController.text);
    var user = credential.user;

    if (user != null) {
      if (user.emailVerified) {
        return SignUpViewModel(
            email: user.email, uid: user.uid, pw: pwTextController.text);
      }
    }
    return null;
  }

  /// 날짜 : 2023.03.24
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 비밀번호를 위한 정규식
  /// 비고 :
  /// 수정 :
  bool isValidPassword(String value) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value);
  }

  /// 날짜 : 2023.03.24
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 이메일을 위한 정규식
  /// 비고 :
  /// 수정 :
  bool isValidEmailFormat(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  /// 날짜 :2023.03.16
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 삭제이 : 권순형
  /// 내용 : SharedPreferences에 email 값 입력하는 함수
  /// 삭제 이유 : sharedPreference는 로그인 할 때만
  // _setEmailSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('email', emailText);
  // }
  //------------------------------------------------------------------------------------
}
