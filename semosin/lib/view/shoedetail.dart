import 'package:flutter/material.dart';
import 'package:semosin/widget/shoe.dart';

class ShoeDetail extends StatefulWidget {
  const ShoeDetail({super.key, required this.modelName});

  // click 시 모델 이름 받아오기
  final String modelName;

  @override
  State<ShoeDetail> createState() => _ShoeDetailState();
}

class _ShoeDetailState extends State<ShoeDetail> {
  // ------------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : shoe detail 정보 보여주기
  late bool isLoading;

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    // 해당 모델의 데이터 받아오는 거 함수 호출
    await selectModelNameData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? loadingTrueWidget() : getDataWidget();
  }

  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : 로딩 중일 때 뜰 위젯
  loadingTrueWidget() {
    //
  }

  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : 데이터 받아 왓을 때 뜰 위젯
  getDataWidget() {
    //
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // backend
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : shoe detail 정보 보여주기
  Future<Shoe> selectModelNameData() {
    //
  }
}
