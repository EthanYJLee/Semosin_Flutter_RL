import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreFavorite {
  /// 날짜 :2023.03.21
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : shoeslist에서 shoedetail갈때 user favorites에 저장 되어있는지
  /// true, false로 return
  Future<bool> isFavorite(modelName) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    List docId = [];
    late bool result;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('favorites')
        .get();

    for (var doc in snapshot.docs) {
      doc.id;
      docId.add(doc.id);
    }
    result = docId.contains(modelName);
    return result;
  }
}
