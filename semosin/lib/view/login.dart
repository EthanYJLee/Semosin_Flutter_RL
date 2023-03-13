import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : login 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // 없음
      body: Center(
        child: Column(
          children: const [
            // 신발 이미지
            // 타이틀
            // 이메일 tf
            // 비밀번호 tf
            // 로그인 버튼 : login()
            // 비밀번호 찾기 버튼 : findPassword page로 이동
            // 구글 로그인 버튼 : googleLoginAPI()
            // 회원가입 버튼 : SignUp page 이동
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------------------
  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : login 버튼 클릭시 firebaseAuth에 확인 하기
  Future<void> login() async {
    // firebaseAuth와 연결하는 객체 생성 후 함수 불러오기
    // 함수 매개변수로 이메일값과 비밀번호 넘기기
    // 리턴값 true false 로 로그인 확인 하기
    // true 이면 페이지 넘기고 아니면 말기
  }

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : 구글 로그인 API service class와 연결 하는 함수
  Future<void> googleLoginAPI() async {
    // service -> GoogleAPI 객체 생성 후 함수 불러오기
  }
}
