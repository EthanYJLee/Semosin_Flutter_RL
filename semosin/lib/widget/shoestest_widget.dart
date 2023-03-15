import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageFromFirestore extends StatefulWidget {
  ImageFromFirestore({Key? key}) : super(key: key);

  @override
  _ImageFromFirestoreState createState() => _ImageFromFirestoreState();
}

class _ImageFromFirestoreState extends State<ImageFromFirestore> {
  final ScrollController _scrollController = ScrollController();
  final int _limit = 5;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false; //로딩 중인지 아닌지 확인하기 위한 선언
  List<DocumentSnapshot> _documents = []; //문서를 가져와서 사용하기 위한 선언
  // late final URL;
  late List imagePathList;
  late List imageURL;
  @override
  void initState() {
    super.initState();
    imagePathList = [];
    imageURL = [];
    _getDocuments();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        print('_getDocuments');
        _limit;
        print(_limit);
        _getDocuments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _documents.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _documents.length) {
            return _isLoading
                ? Center(
                    child: CircularProgressIndicator(), //불러들일 때, 로딩창
                  )
                : Container();
          }
          return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  imageURL.length > index
                      ? Image.network(
                          imageURL[index],
                          // URL,
                          width: MediaQuery.of(context).size.width -
                              30, //핸드폰에 맞게 사이즈 조정
                          fit: BoxFit.cover,
                        )
                      : Container(), //만약 이미지가 없을 경우에는 아무것도 띄우기 않겠다.
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getDocuments() async {
    //이미지는 경로를 따로 가져와서 URL을 다시 생성해서 Image.network에서 출력해야 되기 때문에
    //함수를 따로 만들어서 경로를 불러와야함.
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      //매 호출마다 5개씩 추가되게끔 되어있다.
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
    if (documents.isNotEmpty) {
      for (final doc in documents) {
        final List<dynamic> images = doc['images'];
        String imagePath = images[0].substring(1); //첫번째 문자 .을 지우겠따.
        String URL =
            await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
        imagePathList.add(imagePath);
        imageURL.add(URL);
        print(imagePath);
        print('imagePath입니다.');
      }
      setState(() {
        _documents.addAll(documents);
        _lastDocument = documents.last;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
