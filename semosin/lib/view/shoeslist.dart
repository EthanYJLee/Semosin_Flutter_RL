import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/widget/brand_list.dart';

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
  late TextEditingController serach;
  // late List data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serach = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // app bar 없애서 필요
            SizedBox(
              height: mq.height * 0.1,
            ),
            // 검색
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
            // 브랜드 버튼
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
                    //
                  },
                  child: const Text('임시 가격높은순'),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            // Future.builder
            //    - listview.builder 들어갈거 가 widget -> shoe.dart
            //        - 참고사항 : future builder로 부터 받아온 값들을 ShoeViewModel 생성자에 넣어줘야 된다.
            Column(
              children: [],
            ),
          ],
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
  // firestore_select -> selectShoesAndLike() 함수 호출 해서 데이터 값 받기
  // }
}
