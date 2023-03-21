import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/widget/brand_list.dart';
import 'package:semosin/view/shoedetail.dart';
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
  /// 만든이 : 호식, 오수
  /// 내용 : 검색 , 브랜드 버튼, 정렬 방법 , list view
  /// 상세 내용 : login 한적 있으면 Home , 없으면 Welcome
  late TextEditingController serach;
  // late List data;
  late FireStoreSelect fireStoreSelect;
  late List<String> images;
  late ImagePathViewModel imagePathViewModel;
  late String brandName;
  late bool status;

  @override
  void initState() {
    fireStoreSelect = FireStoreSelect();
    images = [];
    imagePathViewModel = ImagePathViewModel(imagePath: []);
    serach = TextEditingController();
    super.initState();
    brandName = '';
    status = false;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // app bar 없애서 필요
              SizedBox(
                height: mq.height * 0.1,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // children: [
                child: BrandHorizontalList(context),
                // ],
              ),
              // drop box
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // fireStoreSelect.selectBrandShoes('나이키');
                        brandName = '나이키';
                      });
                    },
                    child: const Text('임시 나이키'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // fireStoreSelect.selectBrandShoes('아디다스');
                        brandName = '아디다스';
                      });
                    },
                    child: const Text('임시 아디다스'),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
              // Future.builder ----------------------------------------------------------------
              //    - listview.builder 들어갈거 가 widget -> shoe.dart
              //        - 참고사항 : future builder로 부터 받아온 값들을 ShoeViewModel 생성자에 넣어줘야 된다.

              SizedBox(
                // width: 300,
                width: mq.width * 0.8,
                height: mq.height * 2,
                child: FutureBuilder(
                  future: fireStoreSelect.selectBrandShoes(brandName),
                  // : FutureBuilder(
                  //   future: fireStoreSelect.selectShoes()

                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // getImageURL(snapshot.data!.images[0] as List<String>);
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          // getImageURL(snapshot.data![index].shoeImageName
                          // as List<String>);
                          return Card(
                            // Image.network(imagePathViewModel.imagePath[0]),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShoeDetail(
                                              // modelName: '그랜드 코트 베이스 2.0')));
                                              modelName: snapshot.data![index]
                                                  .shoeModelName)));
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
                      return Text('asd');
                    }
                  },
                ),
              ),
            ],
          ),
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
