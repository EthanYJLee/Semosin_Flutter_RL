import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Model {
  final StreamController<List<String>> _imagesController =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get imagesStream => _imagesController.stream;

  final int _limit = 5;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  List<String> _images = [];

  Future<void> getDocuments() async {
    if (_isLoading) return;
    _isLoading = true;

    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .limit(_limit)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .startAfterDocument(_lastDocument!)
          .limit(_limit)
          .get();
    }

    final documents = querySnapshot.docs;
    final List<String> urls = [];
    for (final doc in documents) {
      final List<dynamic> images = doc['images'];
      final String imagePath = images[0].substring(1); // 첫번째 문자 .을 지움
      final String url =
          await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      urls.add(url);
    }

    _images.addAll(urls);
    _imagesController.add(_images);

    _lastDocument = documents.last;
    _isLoading = false;
  }
}
