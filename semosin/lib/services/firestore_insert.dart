import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreInsert {
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : model 이름 firestore user favorites에 넣기
  insertFavorite(modelName, brandName, image, price) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('favorites')
        .doc(modelName)
        .set({
      'model': modelName,
      'brand': brandName,
      'image': image,
      'price': price,
      'initdate': DateTime.now().toString().substring(0, 19),
    });
  }
}
