import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : login 화면
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // 신발 이미지
                const SizedBox(
                  height: 120,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset("images/converse.png"),
                ),
                // 타이틀
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 이메일 tf
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // 비밀번호 tf
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // 자동 로그인 체크박스
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: CheckboxChange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      activeColor: Colors.black,
                    ),
                    const Text('Remeber me'),
                  ],
                ),
                // 로그인 버튼 : login()
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      //
                    },
                    child: const Text("Sign in with password"),
                  ),
                ),
                // 비밀번호 찾기 버튼 : findPassword page로 이동
                TextButton(
                  onPressed: () {
                    //
                  },
                  child: const Text(
                    "Forgot the password?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                //
                const Text(
                  "or continue with",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                // 구글 로그인 버튼 : googleLoginAPI()
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        //
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
                ),
                // 회원가입 버튼 : SignUp page 이동
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
                        //
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
        ),
      ),
    );
  }

  // ----switch
  void CheckboxChange(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

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
