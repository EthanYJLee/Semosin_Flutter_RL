import 'package:flutter/material.dart';
import 'package:semosin/view_model/shoe_view_model.dart';

class Shoe extends StatelessWidget {
  const Shoe({super.key, required this.shoeViewModel});
  // ------------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : shoeslist listview builder child로 들어갈 값

  // 필드 선언
  final ShoeViewModel shoeViewModel;

  // 위젯 그리기
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // 관심 선택 이미지 or 버튼
          // 신발 이미지
          // Row
          //    Column
          //        신발 모델명
          //        신발 가격
          //    브랜드 이미지
        ],
      ),
    );
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // backend
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : 이미지 관심 선택 시 user에 favorites에 추가하기
  insertFavorite() {
    // FireStoreInsert와 연결하여 함수 호출 : insertFavorite()
  }

  // ------------------------------------------------------------------------------------------
}
