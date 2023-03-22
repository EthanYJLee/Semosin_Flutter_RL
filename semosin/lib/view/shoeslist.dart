import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:semosin/widget/brand_list.dart';
import 'package:semosin/view/shoedetail.dart';
import 'package:semosin/widget/not_read.dart';

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
  /// 만든이 : 호식, 오수
  /// 내용 : 검색 , 브랜드 버튼, 정렬 방법 , list view
  /// 상세 내용 : login 한적 있으면 Home , 없으면 Welcome
  late TextEditingController serach;
  late List<String> images;
  late StreamController<String> streamController;
  late StreamController<List<ShoeViewModel>> streamSheoList;

  @override
  void initState() {
    super.initState();

    images = [];
    serach = TextEditingController();
    streamController = StreamController<String>();
    streamSheoList = StreamController<List<ShoeViewModel>>();

    // stream 초기값 지정
    firstStreamList();

    // streamController 이벤트 추가
    streamEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // app bar 없애서 필요
            const SizedBox(
              height: 20,
            ),
            // 검색 ---------------------
            TextField(
              controller: serach,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Product',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // 브랜드 버튼 ----------------------------------------------------------------
            Center(
              child: BrandHorizontalList(context, streamController),
            ),
            const SizedBox(
              height: 20,
            ),
            // Future.builder ----------------------------------------------------------------
            //    - listview.builder 들어갈거 가 widget -> shoe.dart
            //        - 참고사항 : future builder로 부터 받아온 값들을 ShoeViewModel 생성자에 넣어줘야 된다.
            Expanded(
              child: StreamBuilder(
                stream: streamSheoList.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShoeDetail(
                                              modelName: snapshot
                                                  .data![index].shoeModelName,
                                            )));
                                print(snapshot.data![index].shoeImageName);
                              },
                              child: Column(
                                children: [
                                  // Image.network(
                                  //     snapshot.data![index].shoeImageName),
                                  Text(snapshot.data![index].shoeBrandName),
                                  Text(snapshot.data![index].shoeModelName),
                                  Text(snapshot.data![index].shoePrice),
                                ],
                              )),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button ------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.card_travel), // 임시로 넣어둠. 장바구니 이미지로 바꾸기
      ),
    );
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // stream 관련
  void streamEvent() {
    streamController.stream.listen((event) {
      if (event != 'all') {
        addStreamList(event);
        // } else if (event == '조던' || event == '푸마' || event == '아식스') {
        //   NotReady()
      } else {
        firstStreamList();
      }
    });
  }

  void addStreamList(String brandName) {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectBrandShoes(brandName).then((value) {
      streamSheoList.add(value);
    });
  }

  void firstStreamList() {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectShoes().then((value) {
      streamSheoList.add(value);
    });
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // Backend
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : 신발 데이터 select 위해 firestore와 연결되는 객체 생성 및 함수 호출
  // Future<List<ShoeViewModel>> selectShoesAndLike() async {
  // firestore_select -> selectShoesAndLike() 함수 호출 해서 데이터 값 받기
  // var snapShotsValue = await fireStoreSelect.selectShoes();
  // var snapShotsValue = await FirebaseFirestore.instance
  //     .collection("shoes")
  //     .where('brand', isEqualTo: "아디다스")
  //     .get();
  // List<ShoeViewModel> list = snapShotsValue.docs
  //     .map((e) => ShoeViewModel(
  //           shoeModelName: e.data()['model'],
  //           shoeBrandName: e.data()['brand'],
  //           shoePrice: e.data()['price'],
  //           shoeImageName: e.data()[
  //               'price'], // ************* <<<<<<<<<<<<<<<<<<<< Image 임시 가격으로 진행 - 호식
  //           isLike:
  //               true, // ************* <<<<<<<<<<<<<<<<<<<< isLike 임시 true 진행 - 호식
  //         ))
  //     .toList();
  // return list;
  // } //  selectShoesAndLike END
}

// Future<List<ShoeViewModel>> selectShoes() async {
//   List<ShoeViewModel> shoeViewModelList = [];

//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('shoes').get();
//   for (var document in querySnapshot.docs) {
//     ShoeViewModel shoeViewModel =
//         ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
//     shoeViewModelList.add(shoeViewModel);
//   }
//   return shoeViewModelList;
// }

Future<void> getImageURL(List<String> path) async {
  List<String> pathList = [];
  // for (int i = 0; i < path.length; i++) {
  var downloadURL = await FirebaseStorage.instance
      .ref('신발 이미지')
      .child(path[0].substring(8))
      .getDownloadURL();
  // setState(() {
  pathList.add(downloadURL.toString());
  // });
  // }
  // if (mounted) {
  //   setState(() {
  //     images = pathList;
  //     imagePathViewModel = ImagePathViewModel(imagePath: pathList);
  //   });
  // }
}
