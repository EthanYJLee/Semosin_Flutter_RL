import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/favorite_list.dart';
import 'package:semosin/view/order_status.dart';
import 'package:semosin/view/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  FireStoreSelect userInfo = FireStoreSelect();
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    sharedPreference();
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
