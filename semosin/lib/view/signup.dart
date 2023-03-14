import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

/// 날짜 : 2023.03.13
/// 작성자 : 송명철, 신오수
/// 만든이 :
/// 내용 : sign up 화면
class _SignupState extends State<Signup> {
  late TextEditingController emailTextController;
  late TextEditingController nameTextController;
  late TextEditingController nicknameTextController;
  late TextEditingController phoneTextController;
  late TextEditingController address1TextController;
  late TextEditingController address2TextController;
  late TextEditingController postcodeTextController;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    nameTextController = TextEditingController();
    nicknameTextController = TextEditingController();
    phoneTextController = TextEditingController();
    address1TextController = TextEditingController();
    address2TextController = TextEditingController();
    postcodeTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
        ), //
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // email - tf (disabled)
                textFormField(emailTextController, true,
                    TextInputType.emailAddress, 'email', null),
                // name - tf
                textFormField(nameTextController, false, TextInputType.text,
                    'name', null),
                // nickname - tf : nicknameDuplicationCheck()
                textFormField(nicknameTextController, false, TextInputType.text,
                    'nickname', null),
                // sex - radio button
                // phone - tf
                textFormField(phoneTextController, false, TextInputType.phone,
                    'phone', null),
                // address1- tf(disabled) - api
                Row(
                  children: [
                    SizedBox(
                      width: 285,
                      child: textFormField(address1TextController, true,
                          TextInputType.text, 'address', null),
                    ),
                    SizedBox(
                      width: 100,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        onPressed: () {
                          addressAPI();
                        },
                        child: const Text(
                          '주소검색',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // postcode - tf(disabled) - api
                textFormField(postcodeTextController, true,
                    TextInputType.number, 'postcode', null),
                // address2 - tf
                textFormField(address2TextController, false, TextInputType.text,
                    'address detail', null),
                // 회원가입 버튼 : insertUserInfo()
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () {},
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFormField(controller, readOnly, keyboardType, label, onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
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
        onChanged: (value) {
          onChanged;
        },
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
