import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpostal/kpostal.dart';
import 'package:semosin/services/firestore_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../services/firestore_select.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late String userName;
  late String userEmail;
  late String userPasswd;
  late String userAddress;
  late String userDetailAddress;
  late String userPostCode;
  User? user;

  late TextEditingController pwTextController;
  late TextEditingController checkpwTextController;
  late TextEditingController addressTextController;
  late TextEditingController detailAddressTextController;
  late TextEditingController postCodeTextController;
  FireStoreSelect userInfo = FireStoreSelect();
  FirestoreUpdate userInfoUpdate = FirestoreUpdate();

  @override
  void initState() {
    super.initState();

    userName = "";
    userEmail = "";
    userPasswd = "";
    userAddress = "";
    userDetailAddress = "";
    userPostCode = "";
    pwTextController = TextEditingController();
    checkpwTextController = TextEditingController();
    addressTextController = TextEditingController();
    detailAddressTextController = TextEditingController();
    postCodeTextController = TextEditingController();
  }

  //------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.21
  /// 작성자 : 이상혁
  /// 만든이 : 이성연, 이상혁
  /// 내용 :  My Page 화면

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('./images/googlelogo.png'),
              backgroundColor: Colors.white,
            ),
          ),
          Column(
//        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              profile(),
              const SizedBox(
                height: 40,
              ),
              ChangeProfile(),
              const SizedBox(
                height: 40,
              ),
              ChangPassword(),
              const SizedBox(
                height: 40,
              ),
/*
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      deleteUser();
                    },
                    child: const Text(
                      '탈퇴하기',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
*/
            ],
          ),
        ],
      ),
    );
  }

  // Widget Start ----------------------
  Widget profile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: userInfo.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name'),
                    Text(
                      '${snapshot.data!.name} 님',
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 1, height: 1, color: Colors.grey),
                    Text('Email'),
                    Text(
                      '${snapshot.data!.email}',
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 1, height: 1, color: Colors.grey),
                  ],
                ),
              ],
            );
          } else {
            return ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              title: const CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget ChangeProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: userInfo.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(thickness: 1, height: 1, color: Colors.grey),
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '${snapshot.data!.address}',
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Divider(thickness: 1, height: 1, color: Colors.grey),
                  const Text(
                    'Detail Address :',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${snapshot.data!.addressDetail}',
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Divider(thickness: 1, height: 1, color: Colors.grey),
                  const Text(
                    'Post Code :',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${snapshot.data!.postcode}',
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 1, height: 1, color: Colors.grey),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        takeAddress();
                      },
                      child: const Text(
                        '변경',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              title: const CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  // Widget Start ----------------------
  Widget ChangPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: userInfo.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // Text(
                    //   '' * '${userPasswd = snapshot.data!.password}'.length,
                    // ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showPasswordChangeDialog(context);
                      },
                      child: const Text(
                        '변경',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              title: const CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  /// Desc : 패스워드 변경 Alert Dialog
  /// Date : 2023.03.21
  /// Modified : sanghyuk
  Future<void> _showPasswordChangeDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('패스워드 변경'),
            content: const Text('패스워드를 변경하시겠습니까?'),
            actions: [
              // 비밀번호 tf
              textFormField(pwTextController, null, false, TextInputType.text,
                  true, 'New Password', null, null),
              // 비밀번호 확인 tf
              textFormField(checkpwTextController, null, false,
                  TextInputType.text, true, 'Check Password', null, null),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      if (validatePassword(pwTextController.text)) {
                        if ((pwTextController.text ==
                            checkpwTextController.text)) {
                          print('pwTextController:' + pwTextController.text);
                          print('checkpwTextController:' +
                              checkpwTextController.text);

                          userInfoUpdate.changePassword(pwTextController.text);
                          inputPassword(pwTextController.text);
                          Navigator.of(context).pop();
                          pwTextController.text = "";
                          checkpwTextController.text = "";
                          SharedPreferences.getInstance().then((value) {
                            final pref = value;
                            pref.remove("saemosin-auto-login-status");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyApp()));
                          });
                        } else {
                          print('Password Change Failed');
                          _ErrorPasswordDialog(
                              context, "비밀번호가 동일하지 않거나 현재비밀번호와 다릅니다!");
                          Navigator.of(context).pop();
                        }
                      } else {
                        print("정규식이 맞지 않습니다. False");
                        _ErrorPasswordDialog(context,
                            "비밀번호는대/소문자 각 1자이상, 특수문자를 사용하여 8자이상으로 적어주세요!");
                      }
                      ;
                    },
                  ),
                  TextButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ],
          );
        });
  }

  // child widget
  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 수정이 : 권순형 , 이영진
  /// 내용 : sign up에 사용되는 textField
  /// 비고 : obscureText를 추가함(상혁)
  textFormField(controller, focusNode, readOnly, keyboardType, obscureText,
      label, inputFormatters, onChanged) {
    return SizedBox(
      width: 290,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            setState(() {});
          },
        ),
      ),
    );
  }

  /// 날짜 : 2023.03.13
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : Kpostal openAPI 이용하여 주소 정보 가져오기
  /// 수정사항 : 예외 처리
  Future<void> takeAddress() async {
    Kpostal result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KpostalView(),
        ));
    setState(() {
      // print(result.address);
      // print(result.postCode);
      userAddress = result.address;
      userPostCode = result.postCode;
    });
    _showDetailAddressDialog(context);
  }

  /// 날짜 : 2023.03.21
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : Detail Address 입력을 위한 Dialog
  /// 비고 :
  Future<void> _showDetailAddressDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('상세 주소 입력'),
          content: const Text('상세 주소를 입력해주세요.'),
          actions: <Widget>[
            // 상세주소입력 tf
            textFormField(detailAddressTextController, null, false,
                TextInputType.text, false, 'Detail Address', null, null),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    userDetailAddress = detailAddressTextController.text;
                    userInfoUpdate.changeAddress(
                        userAddress, userDetailAddress, userPostCode);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  /// 날짜 : 2023.03.21
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : FireAuth User Delete
  /// 비고 : Firestore 에서 User 정보에 deleteDate를 추가
  /// 수정 : deleteDate를 업데이트 하는 메소드를 서비스로 옮김.
  ///       deleteDate가 있으면 로그인이 안되도록 추가가 필요함.
  Future<void> deleteUser() async {
    // DeleteDate 추가
    userInfoUpdate.updateDeletedate();
    // Firebase 로그아웃
    //await FirebaseAuth.instance.signOut();
    //await _googleSignIn.signOut();
    SharedPreferences.getInstance().then((value) {
      final pref = value;
      pref.remove("saemosin-auto-login-status");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MyApp()));
    });
  }

  getUserInfo() async {
    FireStoreSelect().getUserInfo();
  }

  bool validatePassword(String value) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value);
  }

  Future<void> _ErrorPasswordDialog(
    BuildContext context,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
        );
      },
    );
  }

  Future<void> inputPassword(String newpassword) async {
    final pref = await SharedPreferences.getInstance();
    final prefPw = pref.getString("saemosinpassword") ?? "0";
    if (newpassword != prefPw) {
      pref.setString("saemosinpassword", newpassword);
    }
  }
}
