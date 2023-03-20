import 'package:flutter/material.dart';
import 'package:semosin/view/login.dart';
import 'package:semosin/view/signup.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  late bool? _isAccountSaved = false;
  late bool? _isLoginAuto = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 : 이영진
  /// 내용 : welcome 초기 화면
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              // 신발 이미지
              const SizedBox(
                height: 100,
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
                height: 30,
              ),

              // 이메일 tf
              _textFormField(_emailController, _emailFocus, false,
                  TextInputType.emailAddress, false, 'Email', null, null),

              // 비밀번호 tf
              _textFormField(_passwordController, _passwordFocus, false,
                  TextInputType.text, true, 'Password', null, null),

              // 이메일 저장 / 자동 로그인 CheckBox
              _rememberAccount(),

              // 로그인 버튼 : login()
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    // email, password
                    // _verifyAccount(_emailController.text.trim(), _passwordController.text.trim()){}
                    
                  },
                  child: const Text('Log In'),
                ),
              ),

              // 'or' 텍스트
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("or"),
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
                    //-----
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

              /// --------------------------------------------------------------------------------------
              /// Desc : 로그인 화면 이동 버튼 - Login 페이지 이동
              /// Update : 나눠져있던 구글 로그인 화면과 이메일 로그인 화면을 Welcome에 병합
              /// Date : 2023.03.15
              /// Author : youngjin Lee
              ///
              // SizedBox(
              //   width: 300,
              //   height: 50,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.black,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20))),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const Login(),
              //         ),
              //       );
              //     },
              //     child: const Text("Sign in with password"),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              /// --------------------------------------------------------------------------------------

              // 회원 가입 이동 버튼 : SignUp 페이지 이동
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
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
              ),

              // 비밀번호 찾기 버튼 : findPassword page로 이동
              TextButton(
                  onPressed: () {
                    // -------------
                  },
                  child: const Text(
                    'Forget the Password?',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : 구글 로그인 API service class와 연결 하는 함수
  Future<void> googleLoginAPI() async {
    // service -> GoogleAPI 객체 생성 후 함수 불러오기
  }

  /// Desc : 이메일과 비밀번호 입력받는 TextFormField
  /// Date : 2023.03.15
  /// Author : youngjin lee
  Widget _textFormField(controller, focusNode, readOnly, keyboardType,
      obscureText, label, inputFormatters, onChanged) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
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

  /// Desc : '회원정보 기억하기' Check Box
  /// Date : 2023.03.15
  /// Author : youngjin lee
  Widget _rememberAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            value: _isAccountSaved,
            onChanged: (value) {
              setState(() {
                _isAccountSaved = value;
                // ----------------------
              });
            }),
        const Text('이메일 저장'),
        Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            value: _isLoginAuto,
            onChanged: (value) {
              setState(() {
                _isLoginAuto = value;

                /// ----------------------
                /// 체크시 SharedPreferences에 토큰, 아이디, 만료일 등을 넣어주고 Main에서 Stream으로 받도록?
              });
            }),
        const Text('자동 로그인'),
      ],
    );
  }
}
