import 'package:flutter/material.dart';
import 'package:semosin/view/login.dart';
import 'package:semosin/view/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  signInWithGoogle() async {
    // Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // // Obtain the auth details from the request
    // final GoogleSignInAuthentication? googleAuth =
    //     await googleUser?.authentication;

    // // Create a new credential
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    // // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : welcome 초기 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // 신발 이미지
            const SizedBox(
              height: 180,
            ),
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset("images/converse.png"),
            ),
            const SizedBox(
              height: 40,
            ),
            // 타이틀
            const Text(
              "Welcome!!",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 80,
            ),

            // 구글 로그인 버튼 : googleLoginAPI()
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  signInWithGoogle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "images/googlelogo.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const Text(
                      "Continue With Google",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // or 텍스트
            const Text("or"),
            const SizedBox(
              height: 25,
            ),
            // 로그인 화면 이동 버튼 : Login 페이지 이동
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text("Sign in with password"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // 회원 가입 이동 버튼 : SignUp 페이지 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have account?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
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
