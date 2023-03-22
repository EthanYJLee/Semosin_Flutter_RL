import 'package:flutter/material.dart';
import 'package:semosin/main.dart';
import 'package:semosin/view/shoedetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoeDetail(
                                modelName: '그랜드 코트 베이스 2.0',
                                brandName: '아디다스',
                              )));
                },
                child: const Text('상세보기')),
          ],
        ),
      ),
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
  //   // firestore_select -> selectShoesAndLike() 함수 호출 해서 데이터 값 받기
  // }
}
