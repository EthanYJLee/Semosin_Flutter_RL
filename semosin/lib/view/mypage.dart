import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/favorite_list.dart';
import 'package:semosin/view/order_status.dart';
import 'package:semosin/view/userinfopage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  FireStoreSelect userInfo = FireStoreSelect();
  late SharedPreferences pref;
  late TextEditingController passwordTextController;

  @override
  void initState() {
    super.initState();
    sharedPreference();

    passwordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          profile(),
          btnInfoUpdate(),
          orderStatusBoard(),
          bottomList(),
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
            return ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('./images/googlelogo.png'),
                backgroundColor: Colors.white,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${snapshot.data!.name} 님',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                snapshot.data!.email,
                style: const TextStyle(),
              ),
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

  Widget btnInfoUpdate() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.09,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black12),
        child: TextButton(
          style: const ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) {
            //     return UserInfoPage();
            //   },
            // ));
            _showPasswordCheckDialog(context);
            print('btnInfoUpdate onTap');
          },
          child: const Text(
            '회원정보 수정',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget orderStatusBoard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const OrderStatus();
            },
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.24,
            decoration: BoxDecoration(border: Border.all(width: 0.1)),
            child: const ListTile(
              textColor: Colors.black,
              title: Text(
                '결제',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '2',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.24,
            decoration: BoxDecoration(border: Border.all(width: 0.1)),
            child: const ListTile(
              textColor: Colors.black,
              title: Text(
                '배송 중',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '3',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.24,
            decoration: BoxDecoration(border: Border.all(width: 0.1)),
            child: const ListTile(
              textColor: Colors.black,
              title: Text(
                '배송 완료',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '5',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white12,
            maxRadius: MediaQuery.of(context).size.width * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.chevron_right_circle,
                  color: Colors.black45,
                ),
                Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottomList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const FavoriteList();
                },
              ));
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              child: const ListTile(
                shape: Border(
                  top: BorderSide(width: 0.2),
                  bottom: BorderSide(width: 0.2),
                ),
                minLeadingWidth: 10,
                leading: Icon(
                  CupertinoIcons.heart,
                ),
                title: Text(
                  '관심있는 상품',
                ),
                trailing: Icon(CupertinoIcons.chevron_right_circle),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('고객센터 onTap');
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              child: const ListTile(
                shape: Border(
                  bottom: BorderSide(width: 0.2),
                ),
                minLeadingWidth: 10,
                leading: Icon(
                  CupertinoIcons.headphones,
                  // color: Colors.red,
                ),
                title: Text(
                  '고객센터',
                ),
                trailing: Icon(CupertinoIcons.chevron_right_circle),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const OrderStatus();
                  },
                ),
              );
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              child: const ListTile(
                shape: Border(
                  bottom: BorderSide(width: 0.2),
                ),
                minLeadingWidth: 10,
                leading: Icon(
                  CupertinoIcons.square_list,
                ),
                title: Text(
                  '주문확인',
                ),
                trailing: Icon(CupertinoIcons.chevron_right_circle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Desc : 패스워드 변경 Alert Dialog
  /// Date : 2023.03.21
  /// Modified : sanghyuk
  Future<void> _showPasswordCheckDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원정보 수정'),
            content: const Text('패스워드를 입력하세요'),
            actions: [
              // 현재비밀번호 tf
              textFormField(passwordTextController, null, false,
                  TextInputType.text, true, 'Password', null, null),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      final prefPw = pref.getString("saemosinpassword") ?? "0";
                      if (passwordTextController.text == prefPw) {
                        passwordTextController.text = "";
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const UserInfoPage();
                          },
                        ));
                      } else {
                        //print('Password Change Failed');
                        _errorPasswordDialog(context, "비밀번호가 틀렸습니다!");
                        //Navigator.of(context).pop();
                      }
                    },
                  ),
                  TextButton(
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
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

  Future<void> _errorPasswordDialog(
    BuildContext context,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, "OK");
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  // Widget End ------------------------

  // Function Start ----------------------

  getUserInfo() async {
    FireStoreSelect().getUserInfo();
  }

  sharedPreference() async {
    pref = await SharedPreferences.getInstance();
    // String? email = pref.getString('saemosinemail');
  }

  // Function End ------------------------
}
