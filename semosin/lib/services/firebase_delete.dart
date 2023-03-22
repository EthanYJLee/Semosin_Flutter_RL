import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreDelete {
  /// 날짜 :2023.03.15
  /// 작성자 : 신오수
  /// 만든이 :
  /// 내용 : model 이름 firestore user favorites에서 삭제
  deleteFavorite(modelName) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('favorites')
        .doc(modelName)
        .delete();
  }
}
