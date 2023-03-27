import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreDelete {
  /// 날짜 :2023.03.21
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : favorites 삭제 기능
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

  /// 날짜 :2023.03.23
  /// 만든이 : Hosik
  /// 내용 : Delete Cart
  deleteCart(documentId) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('carts')
        .doc(documentId)
        .delete();
  }
}
