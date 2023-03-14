import 'dart:async';

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
  late TextEditingController addressTextController;
  late TextEditingController addressDetailTextController;
  late TextEditingController postcodeTextController;

  // --- Text Field Focus 관련
  late FocusNode nameFocusNode;
  late FocusNode nicknameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode addressDetailFocusNode;
  //
  late String nameCheckText = "";
  late String nicknameCheckText = "";
  late String phoneCheckText = "";
  late String addressDetailCheckText = "";
  //
  bool nameCheckColor = true;
  bool nicknameCheckColor = true;
  bool phoneCheckColor = true;
  bool addressDetailCheckColor = true;
  // --- Text Field Focus 관련 End

  // late StreamController<String> controller = StreamController();

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    nameTextController = TextEditingController();
    nicknameTextController = TextEditingController();
    phoneTextController = TextEditingController();
    addressTextController = TextEditingController();
    addressDetailTextController = TextEditingController();
    postcodeTextController = TextEditingController();

    // --- Text Field Focus 관련
    //
    nameCheckText = '';
    nicknameCheckText = '';
    phoneCheckText = '';
    addressDetailCheckText = '';
    //
    nameFocusNode = FocusNode();
    nicknameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    addressDetailFocusNode = FocusNode();
    //
    focusListener();
    // --- Text Field Focus 관련 End
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
                textFormField(emailTextController, null, true,
                    TextInputType.emailAddress, 'email', null),
                // name - tf
                textFormField(nameTextController, nameFocusNode, false,
                    TextInputType.text, 'name', null),
                checkText(nameCheckText, nameCheckColor),
                // nickname - tf : nicknameDuplicationCheck()
                textFormField(nicknameTextController, nicknameFocusNode, false,
                    TextInputType.text, 'nickname', null),
                checkText(nicknameCheckText, nicknameCheckColor),
                // sex - radio button
                // phone - tf
                textFormField(phoneTextController, phoneFocusNode, false,
                    TextInputType.phone, 'phone', null),
                checkText(phoneCheckText, phoneCheckColor),
                // address1- tf(disabled) - api
                Row(
                  children: [
                    SizedBox(
                      width: 285,
                      child: textFormField(addressTextController, null, true,
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
                textFormField(postcodeTextController, null, true,
                    TextInputType.number, 'postcode', null),
                // address detail - tf
                textFormField(
                    addressDetailTextController,
                    addressDetailFocusNode,
                    false,
                    TextInputType.text,
                    'address detail',
                    null),
                checkText(addressDetailCheckText, addressDetailCheckColor),
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

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : sign up에 사용되는 textField
  textFormField(
      controller, focusNode, readOnly, keyboardType, label, onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
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

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : textField에서 포커스가 풀릴때 내용이 비어있는지 확인하는 기능
  focusListener() {
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        if (nameTextController.text.trim().isEmpty) {
          setState(() {
            nameCheckText = '이름을 입력하세요.';
            nameCheckColor = false;
            // signUpButtonEnabled[0] = false;
          });
        }
      }
    });
    nicknameFocusNode.addListener(() {
      if (!nicknameFocusNode.hasFocus) {
        if (nicknameTextController.text.trim().isEmpty) {
          setState(() {
            nicknameCheckText = '닉네임을 입력하세요.';
            nicknameCheckColor = false;
            // signUpButtonEnabled[1] = false;
          });
        }
      }
    });
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) {
        if (phoneTextController.text.trim().isEmpty) {
          setState(() {
            phoneCheckText = '전화번호를 입력하세요.';
            phoneCheckColor = false;
            // signUpButtonEnabled[2] = false;
          });
        }
      }
    });
    addressDetailFocusNode.addListener(() {
      if (!addressDetailFocusNode.hasFocus) {
        if (addressDetailTextController.text.trim().isEmpty) {
          setState(() {
            addressDetailCheckText = '상세주소를 입력하세요.';
            addressDetailCheckColor = false;
            // signUpButtonEnabled[2] = false;
          });
        }
      }
    });
  }

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : textField 아래 사용자가 입력 잘 했는지 보여주는 텍스트
  checkText(checkText, checkColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Text(
            checkText,
            style: TextStyle(
                fontSize: 12,
                color: nicknameCheckColor ? Colors.blue : Colors.red),
          ),
        ],
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
