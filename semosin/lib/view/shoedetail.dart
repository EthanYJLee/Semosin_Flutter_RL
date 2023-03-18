import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semosin/model/selected_shoe.dart';
import 'package:semosin/model/shoe.dart';
import 'package:semosin/services/firebase_firestore.dart';
import 'package:semosin/services/shoes_info.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  ShoesInfo shoesInfo = ShoesInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    // 해당 모델의 데이터 받아오는 거 함수 호출
    // await selectModelNameData();
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? loadingTrueWidget() : getDataWidget();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: shoesInfo.selectModelNameData(widget.modelName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 300,
                    width: 200,
                    child: AlertDialog(
                      title: Text(snapshot.data!.brand),
                      content: Text(snapshot.data!.price),
                    ),
                  );
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        )),
      ),
    );
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
}
