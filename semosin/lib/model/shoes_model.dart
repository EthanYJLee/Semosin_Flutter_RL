import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('shoes');

  Future<List<String>> getImageURLs(
      int limit, DocumentSnapshot? lastDocument) async {
    Query query =
        _collectionRef.orderBy('createdAt', descending: true).limit(limit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    final QuerySnapshot snapshot = await query.get();
    final List<String> imageURLs = [];
    for (final doc in snapshot.docs) {
      final List<dynamic> images = doc['images'];
      final String imagePath = images[0].substring(1); //첫번째 문자 .을 지우겠따.
      final String URL =
          await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      imageURLs.add(URL);
    }
    return imageURLs;
  }
}
