import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpostal/kpostal.dart';
import 'package:semosin/services/firebase_firestore.dart';

import '../widget/phone_formatter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

/// 날짜 : 2023.03.13
/// 작성자 : 송명철, 신오수
/// 만든이 : 신오수
/// 내용 : sign up 화면
class _SignupState extends State<Signup> {
  late TextEditingController emailTextController;
  late TextEditingController nameTextController;
  late TextEditingController nicknameTextController;
  late TextEditingController phoneTextController;
  late TextEditingController addressTextController;
  late TextEditingController addressDetailTextController;
  late TextEditingController postcodeTextController;

  // 성별
  late String sex;

  // --- Text Field Focus 관련
  late FocusNode nameFocusNode;
  late FocusNode nicknameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode addressDetailFocusNode;
  //
  late String nameCheckText;
  late String nicknameCheckText;
  late String phoneCheckText;
  late String addressDetailCheckText;
  //
  bool nameCheckColor = false;
  bool nicknameCheckColor = false;
  bool phoneCheckColor = false;
  bool addressDetailCheckColor = false;
  // --- Text Field Focus 관련 End

  // --- 전화번호 TextInputFormatter
  List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    NumberFormatter(),
    LengthLimitingTextInputFormatter(13)
  ];
  // --- 전화번호 TextInputFormatter End

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

    sex = '';

    phoneTextController.text = '010';

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
                    TextInputType.emailAddress, 'email', null, null),
                // name - tf
                textFormField(nameTextController, nameFocusNode, false,
                    TextInputType.text, 'name', null, null),
                // nameCheckText - Text
                checkText(nameCheckText, nameCheckColor),
                // nickname - tf : nicknameDuplicationCheck()
                textFormField(nicknameTextController, nicknameFocusNode, false,
                    TextInputType.text, 'nickname', null, null),
                // nicknameCheckText - Text
                checkText(nicknameCheckText, nicknameCheckColor),
                // sex - radio button
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                      child: Text(
                        '성별',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                sex == '남자' ? Colors.amber : Colors.white),
                        onPressed: () {
                          setState(() {
                            sex = '남자';
                          });
                        },
                        child: const Text(
                          '남자',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                sex == '여자' ? Colors.amber : Colors.white),
                        onPressed: () {
                          setState(() {
                            sex = '여자';
                          });
                        },
                        child: const Text(
                          '여자',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                // phone - tf
                textFormField(phoneTextController, phoneFocusNode, false,
                    TextInputType.number, 'phone', phoneFormatter, null),
                checkText(phoneCheckText, phoneCheckColor),
                // postcode - tf(disabled) - api
                Row(
                  children: [
                    SizedBox(
                      width: 285,
                      child: textFormField(postcodeTextController, null, true,
                          TextInputType.number, 'postcode', null, null),
                    ),
                    SizedBox(
                      width: 100,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        onPressed: () async {
                          takeAddress();
                          // 네트워크 쓰는거 때문에 예외 처리 해야 될듯
                          Kpostal result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KpostalView(),
                              ));
                          setState(() {
                            addressTextController.text = result.address;
                            postcodeTextController.text = result.postCode;
                          });
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
                // address1- tf(disabled) - api
                textFormField(addressTextController, null, true,
                    TextInputType.text, 'address', null, null),
                // address detail - tf
                textFormField(
                    addressDetailTextController,
                    addressDetailFocusNode,
                    false,
                    TextInputType.text,
                    'address detail',
                    null,
                    null),
                checkText(addressDetailCheckText, addressDetailCheckColor),
                // 회원가입 버튼 : insertUserInfo()
                signupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------------------
  // child widget

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : sign up에 사용되는 textField
  textFormField(controller, focusNode, readOnly, keyboardType, label,
      inputFormatters, onChanged) {
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
        inputFormatters: inputFormatters,
        onChanged: (value) {
          onChanged;
        },
      ),
    );
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
                fontSize: 12, color: checkColor ? Colors.blue : Colors.red),
          ),
        ],
      ),
    );
  }

  signupButton() {
    return nameCheckColor &
            nicknameCheckColor &
            phoneCheckColor &
            addressDetailCheckColor &
            addressTextController.text.trim().isNotEmpty &
            postcodeTextController.text.trim().isNotEmpty &
            sex.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  // insertUserInfo();
                },
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
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  null;
                },
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
          );
  }

  // ---------------------------------------------------------------------------------------
  // function

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : textField에서 포커스가 풀릴때 정규식, 빈값확인, 중복확인 진행
  focusListener() {
    nameFocusNode.addListener(() {
      setState(() {
        if (!nameFocusNode.hasFocus) {
          if (nameTextController.text.trim().isEmpty) {
            nameCheckText = '이름을 입력하세요.';
            nameCheckColor = false;
          } else {
            nameCheckText = '';
            nameCheckColor = true;
          }
        } else {
          nameCheckText = '';
          nameCheckColor = false;
        }
      });
    });
    nicknameFocusNode.addListener(() {
      setState(() {
        if (!nicknameFocusNode.hasFocus) {
          if (nicknameTextController.text.trim().isEmpty) {
            nicknameCheckText = '닉네임을 입력하세요.';
            nicknameCheckColor = false;
            // signUpButtonEnabled[1] = false;
          } else {
            nicknameDuplicationCheck();
          }
        } else {
          nicknameCheckText = '';
          nicknameCheckColor = false;
        }
      });
    });
    phoneFocusNode.addListener(() {
      setState(() {
        if (!phoneFocusNode.hasFocus) {
          if (phoneTextController.text.trim() == '010') {
            // 사용자가 010에서 입력을 안했을 경우
            phoneCheckText = '전화번호를 입력하세요.';
            phoneCheckColor = false;
            // signUpButtonEnabled[2] = false;
          } else if (phoneTextController.text.trim().length == 13) {
            // -를 포함한 전화번호 길이가 13일 경우
            if (isValidPhoneNumberFormat(phoneTextController.text.trim())) {
              // 사용자가 정규식을 잘 지켰을 경우
              phoneCheckText = '';
              phoneCheckColor = true;
            } else {
              // 사용자가 정규식을 지키지 않았을 경우
              phoneCheckText = '유효한 전화번호를 입력해주세요.';
              phoneCheckColor = false;
            }
          } else {
            // -를 포함한 전화번호 길이가 13보다 짧을 경우
            phoneCheckText = '올바른 전화번호를 입력해주세요.';
            phoneCheckColor = false;
          }
        } else {
          // phoneTextField에 focus가 있을 경우
          phoneCheckText = '';
          phoneCheckColor = false;
        }
      });
    });
    addressDetailFocusNode.addListener(() {
      setState(() {
        if (!addressDetailFocusNode.hasFocus) {
          if (addressDetailTextController.text.trim().isEmpty) {
            addressDetailCheckText = '상세주소를 입력하세요.';
            addressDetailCheckColor = false;
            // signUpButtonEnabled[2] = false;
          } else {
            addressDetailCheckText = '';
            addressDetailCheckColor = true;
          }
        } else {
          addressDetailCheckText = '';
          addressDetailCheckColor = false;
        }
      });
    });
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 : 신오수
  /// 내용 : nickname 중복체크
  /// 수정사항 : 예외처리
  Future<void> nicknameDuplicationCheck() async {
    bool isDuplicate = await FireStore()
        .duplicationCheck('nickname', nicknameTextController.text);
    setState(() {
      if (isDuplicate) {
        nicknameCheckText = '이미 사용 중인 닉네임입니다.';
        nicknameCheckColor = false;
      } else {
        nicknameCheckText = '사용 가능한 닉네임입니다.';
        nicknameCheckColor = true;
      }
    });
  }

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수, 신오수
  /// 만든이 : 신오수
  /// 내용 : phone 정규식
  bool isValidPhoneNumberFormat(phoneInput) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(phoneInput);
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : Kpostal openAPI 이용하여 주소 정보 가져오기
  /// 수정사항 : 예외 처리
  takeAddress() async {
    Kpostal result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KpostalView(),
        ));
    setState(() {
      addressTextController.text = result.address;
      postcodeTextController.text = result.postCode;
    });
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : 입력정보 firestore에 저장
  /// 수정사항 : 예외처리
  Future<void> insertUserInfo() async {
    await FireStore().insertIntoFirestore(
        'email',
        nameTextController.text.trim(),
        nicknameTextController.text.trim(),
        sex,
        phoneTextController.text.trim(),
        postcodeTextController.text.trim(),
        addressTextController.text.trim(),
        addressDetailTextController.text.trim());
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 송명철, 신오수
  /// 만든이 :
  /// 내용 : 회원가입 성공 Dialog
  signUpSuccessDialog() {
    //
  }
} // End
