import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreUpdate {
  /// Desc : 관심상품 추가 (북마크) 시 Shoes의 Like 수 +/- 해주기
  /// Date : 2023.03.22
  /// Author : youngjin
  incrementLikes(String modelName) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("shoes").doc(modelName);
    late int likesCount;
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        likesCount = data.entries
            .where((element) => element.key == 'like')
            .map((e) => e.value)
            .first;

        likesCount++;
        docRef.update({'like': likesCount});
      },
    );
  }

  decrementLikes(String modelName) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("shoes").doc(modelName);
    late int likesCount;
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        likesCount = data.entries
            .where((element) => element.key == 'like')
            .map((e) => e.value)
            .first;

        likesCount--;
        docRef.update({'like': likesCount});
      },
    );
  }
}
