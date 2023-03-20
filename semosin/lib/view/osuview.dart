import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view_model/shoe_view_model.dart';

import '../view_model/image_path_view_model.dart';

class ShoesList extends StatefulWidget {
  const ShoesList({super.key});

  @override
  State<ShoesList> createState() => _ShoesListState();
}

class _ShoesListState extends State<ShoesList> {
  // ------------------------------------------------------------------------------------------
  // Front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : 검색 , 브랜드 버튼, 정렬 방법 , list view
  /// 상세 내용 : login 한적 있으면 Home , 없으면 Welcome

  late FireStoreSelect fireStoreSelect;
  late List<String> images;
  late ImagePathViewModel imagePathViewModel;

  @override
  void initState() {
    fireStoreSelect = FireStoreSelect();
    images = [];
    imagePathViewModel = ImagePathViewModel(imagePath: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // app bar 없애서 필요
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              // 검색
              // 브랜드 버튼
              // drop box
              // Future.builder
              //    - listview.builder 들어갈거 가 widget -> shoe.dart
              //        - 참고사항 : future builder로 부터 받아온 값들을 ShoeViewModel 생성자에 넣어줘야 된다.
              SizedBox(
                width: 300,
                height: 500,
                child: FutureBuilder(
                  future: fireStoreSelect.selectShoes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          // getImageURL(snapshot.data![index].shoeImageName
                          // as List<String>);
                          return Card(
                              // Image.network(imagePathViewModel.imagePath[0]),
                              child: Column(
                            children: [
                              Text(snapshot.data![index].shoeBrandName),
                              Text(snapshot.data![index].shoeModelName),
                              Text(snapshot.data![index].shoePrice),
                            ],
                          ));
                        },
                      );
                    } else {
                      return Text('asd');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.card_travel), // 임시로 넣어둠. 장바구니 이미지로 바꾸기
      ),
    );
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // Backend
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : 신발 데이터 select 위해 firestore와 연결되는 객체 생성 및 함수 호출
  // Future<List<ShoeViewModel>> selectShoesAndLike() async {
  //   // firestore_select -> selectShoesAndLike() 함수 호출 해서 데이터 값 받기
  // }

  // Future<void> getImageURL(List<String> path) async {
  //   List<String> pathList = [];

  //   for (int i = 0; i < path.length; i++) {
  //     var downloadURL = await FirebaseStorage.instance
  //         .ref('신발 이미지')
  //         .child(path[i].substring(8))
  //         .getDownloadURL();

  //     pathList.add(downloadURL.toString());
  //     print(downloadURL);
  //   }
  //   if (mounted) {
  //     setState(() {
  //       images = pathList;
  //       imagePathViewModel = ImagePathViewModel(imagePath: pathList);
  //     });
  //   }
  // }
}
