import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semosin/view/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleApi {
  /// 날짜 : 2023.03.15
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : 계정정보 중복 방지를 위해 초기화 먼저 진행
  signOutGoogle(context) async {
    showDialog(
      context: context,
      builder: (contexts) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 : 신오수
  /// 내용 : 구글 로그인 API와 연결 하는 함수
  /// 비고 : 리턴 값 있을 시 알려주고 그 값을 받아와야 되는 값들을 model에 만들기
  Future<UserCredential?> googleLogin(context) async {
    // google API와 연결하여 로그인 하는 기능 구현
    try {
      await signOutGoogle(context);
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCheck(context);
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        if (e == 'accessToken != null || idToken != null') {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      }
      return null;

      // Once signed in, return the UserCredential
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        Navigator.pop(context);
      } else if (e.code == 'accessToken != null || idToken != null') {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
      rethrow;
    }
  }

  /// 날짜 : 2023.03.15
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : 구글 로그인시 회원인지 비회원인지 구분하는 기능
  /// 비고 : 회원일시 ShoesTabBar로 비회원일시 Signup으로
  userCheck(context) async {
    // SharePreferences
    final pref = await SharedPreferences.getInstance();
    // ShaerdPreferces 중복 방지를 위해 초기화
    await pref.clear();
    // FirebaseAuth
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          String? email = user.email;
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();
          if (snapshot.docs.isNotEmpty) {
            DocumentSnapshot document = snapshot.docs[0];
            Map<String, dynamic> userData =
                document.data()! as Map<String, dynamic>;
            String? uid = userData['uid'];
            String? email = userData['email'];
            String? name = userData['name'];
            String? nickname = userData['nickname'];

            // SharedPreference에 저장
            pref.setString('uid', uid!);
            pref.setString('email', email!);
            pref.setString('name', name!);
            pref.setString('nickname', nickname!);
            Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) {
            //     return ShoesTabBar();
            //   },
            // ));
          } else {
            pref.setString('uid', user.uid);
            pref.setString('email', user.email!);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const Signup();
              },
            ));
          }
        } else {}
      },
    );
  }
}
