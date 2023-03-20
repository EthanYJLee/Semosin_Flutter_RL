// import 'package:flutter/material.dart';
// import 'package:semosin/view/signup.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;
//   late FocusNode _emailFocus;
//   late FocusNode _passwordFocus;
//   late bool? _isAccountSaved = false;
//   late bool? _isLoginAuto = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _emailFocus = FocusNode();
//     _passwordFocus = FocusNode();
//   }

//   /// 날짜 :2023.03.13
//   /// 작성자 : 권순형
//   /// 만든이 : 이영진
//   /// 작성일 : 2023.03.15
//   /// 내용 : login 화면
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: const IconThemeData(color: Colors.black),
//           elevation: 0,
//         ), // 없음
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 신발 이미지
//               SizedBox(
//                 height: 150,
//                 width: 150,
//                 child: Image.asset("images/converse.png"),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               // 타이틀
//               const Text(
//                 "Sign In",
//                 style: TextStyle(
//                   fontSize: 50,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               // 이메일 tf
//               _textFormField(_emailController, _emailFocus, false,
//                   TextInputType.emailAddress, false, 'Email', null, null),
//               // 비밀번호 tf
//               _textFormField(_passwordController, _passwordFocus, false,
//                   TextInputType.text, true, 'Password', null, null),
//               _rememberAccount(),
//               // 로그인 버튼 : login()
//               SizedBox(
//                 width: 300,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20))),
//                   onPressed: () {},
//                   child: const Text('Log In'),
//                 ),
//               ),
//               // 비밀번호 찾기 버튼 : findPassword page로 이동
//               TextButton(
//                   onPressed: () {
//                     // -------------
//                   },
//                   child: const Text('Forget the Password?')),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have account?",
//                     style: TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Signup(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Sign up",
//                       style: TextStyle(
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Desc : 이메일과 비밀번호 입력받는 TextFormField
//   /// Date : 2023.03.15
//   /// youngjin lee
//   Widget _textFormField(controller, focusNode, readOnly, keyboardType,
//       obscureText, label, inputFormatters, onChanged) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         readOnly: readOnly,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           label: Text(label),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         inputFormatters: inputFormatters,
//         onChanged: (value) {
//           onChanged;
//         },
//       ),
//     );
//   }

//   /// Desc : '회원정보 기억하기' check box
//   /// Date : 2023.03.15
//   /// youngjin lee
//   Widget _rememberAccount() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Checkbox(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             value: _isAccountSaved,
//             onChanged: (value) {
//               setState(() {
//                 _isAccountSaved = value;
//                 // ----------------------
//               });
//             }),
//         const Text('이메일 저장'),
//         Checkbox(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             value: _isLoginAuto,
//             onChanged: (value) {
//               setState(() {
//                 _isLoginAuto = value;

//                 /// ----------------------
//                 /// 체크시 SharedPreferences에 토큰, 아이디, 만료일 등을 넣어주고 Main에서 Stream으로 받도록?
//               });
//             }),
//         const Text('자동 로그인'),
//       ],
//     );
//   }

//   /// 날짜 :2023.03.13
//   /// 작성자 : 권순형
//   /// 만든이 :
//   /// 내용 : login 버튼 클릭시 firebaseAuth에 확인 하기
//   Future<void> login() async {
//     // firebaseAuth와 연결하는 객체 생성 후 함수 불러오기
//     // 함수 매개변수로 이메일값과 비밀번호 넘기기
//     // 리턴값 true false 로 로그인 확인 하기
//     // true 이면 페이지 넘기고 아니면 말기
//   }

//   /// 날짜 :2023.03.13
//   /// 작성자 : 권순형
//   /// 만든이 :
//   /// 내용 : 구글 로그인 API service class와 연결 하는 함수
//   Future<void> googleLoginAPI() async {
//     // service -> GoogleAPI 객체 생성 후 함수 불러오기
//   }
// }
