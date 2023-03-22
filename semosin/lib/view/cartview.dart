import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firebase_firestore.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/hosik_insert_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late String userId;
  late String userPw;
  late String prefEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = "";
    userPw = '';
    prefEmail = '';
    _initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart Test by Hosik',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text(
                      '전체 선택',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text(
                      '전체 해제',
                    ),
                  ),
                ),
              ],
            ),

            // Text()
          ],
        ),
      ),
    );
  }

  // /// ----------

  // Future test() async {
  //   list = await FirebaseUser();
  //   return list;
  // }

  // selectString() {
  //   final pref = SharedPreferences.getInstance();
  //   var result = pref.geteamil.getString(email) ?? "test";
  //   return result;
  // }

  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefEmail = prefs.getString("saemosinemail")!;
    });
    return prefEmail;
  } //  _initSharedPreferences END

} // END

///
/// 1. 유저정보
/// 2. 카트 인설트
///
///
// getFireBaseData() {
//   FirebaseFirestore.instance.collection('users').add(
//     {
//       'Age': usersStaticInfo.userAge,
//       'EDUC': usersStaticInfo.userEduc,
//       'MMSE': usersStaticInfo.userResultMMSE,
//       'SES': usersStaticInfo.userSes,
//       'SexCode': usersStaticInfo.userSex,
//       // 'date': DateTime.now(),
//       'date': DateTime.parse(DateTime.now().toString().substring(0, 16)),
//       'user_id': usersStaticInfo.userId,
//     },
//   );
// } // Firebase upload END
// final String name;
//   final String uid;
//   final String email;
//   final String nickname;
//   final String sex;
//   final String phone;
//   final String address;
//   final String addressDetail;
//   final String postcode;
//   final String initdate;
//   final String updatedate;
//   final String deletedate;
//   final List<Order> orders;
//   final List<Cart> carts;
//   final List<String> favorites;