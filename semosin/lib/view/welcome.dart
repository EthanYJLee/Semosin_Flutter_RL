import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : welcome 초기 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // 없음
      body: Center(
        child: Column(
          children: const [
            // 신발 이미지
            // 타이틀
            // 구글 로그인 버튼 : googleLoginAPI()
            // or 텍스트
            // 로그인 화면 이동 버튼 : Login 페이지 이동
            // 회원 가입 이동 버튼 : SignUp 페이지 이동
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------------------
  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : 구글 로그인 API service class와 연결 하는 함수
  Future<void> googleLoginAPI() async {
    // service -> GoogleAPI 객체 생성 후 함수 불러오기
  }
}
