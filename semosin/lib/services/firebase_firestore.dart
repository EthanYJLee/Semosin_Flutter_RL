import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore {
  /// 날짜 :2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 :
  // TextField에서 받은 값이 firebase firestore에 중복되는 값이 있는지 확인
  // 중복되면 true, 없으면 false
  // 있는지 없는지 값 true false로 보내기
  /// 비고 :
  Future<bool> duplicationCheck(fieldName, textField) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(fieldName, isEqualTo: textField)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  insertIntoFirestore(
      email, name, nickname, sex, phone, postcode, address, addressDetail) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'nickname': nickname,
          'sex': sex,
          'phone': phone,
          'postcode': postcode,
          'address': address,
          'addressDetail': addressDetail
        });
      }
    });
  }
}
