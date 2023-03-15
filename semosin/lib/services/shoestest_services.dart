import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semosin/model/shoes_model.dart';

class ImageViewModel with ChangeNotifier {
  final ImageRepository _repository = ImageRepository();
  final ScrollController _scrollController = ScrollController();
  final int _limit = 5;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  List<String> _imageURLs = [];

  List<String> get imageURLs => _imageURLs;

  Future<void> getDocuments() async {
    if (_isLoading) return;
    _isLoading = true;
    final List<String> imageURLs =
        await _repository.getImageURLs(_limit, _lastDocument);
    if (imageURLs.isNotEmpty) {
      _imageURLs.addAll(imageURLs);
      _lastDocument = null; // 이미지 URL을 가져올 때마다 마지막 Document 초기화
      _lastDocument = FirebaseFirestore.instance
          .collection('shoes')
          .doc(imageURLs.length.toString()) as DocumentSnapshot<Object?>?;
    }
    _isLoading = false;
    notifyListeners();
  }

  void scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getDocuments();
    }
  }
}
