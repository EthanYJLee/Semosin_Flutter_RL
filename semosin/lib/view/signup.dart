import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : sign up 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), //
      body: Center(
        child: Column(
          children: [
            // email - tf (disabled)
            // name - tf
            // nickname - tf : nicknameDuplicationCheck()
            // sex - radio button
            // phone - tf
            // address1- tf(disabled) - api
            // postcode - tf(disabled) - api
            // address2 - tf
            // 회원가입 버튼 : insertUserInfo()
          ],
        ),
      ),
    );
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : nickname 중복체크
  Future<void> nicknameDuplicationCheck() async {
    //
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : 주소 api
  Future<void> addressAPI() async {
    // service -> addressAPI 객체 생성 후 함수 불러오기
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : 입력정보 firestore에 저장
  Future<void> insertUserInfo() async {
    //
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : 회원가입 성공 Dialog
  signUpSuccessDialog() {
    //
  }
}
