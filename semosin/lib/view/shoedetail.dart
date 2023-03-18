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
import 'package:semosin/view_model/image_path_view_model.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShoeDetail extends StatefulWidget {
  const ShoeDetail({super.key, required this.modelName});

  // click 시 모델 이름 받아오기
  final String modelName;

  // image path 받아오기

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
  late ImagePathViewModel imagePathViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePathViewModel = ImagePathViewModel(imagePath: []);

    isLoading = true;
    // 해당 모델의 데이터 받아오는 거 함수 호출
    // await selectModelNameData();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  getImageURL(snapshot.data!.images as List<String>);
                  return Column(
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        child: imagePathViewModel.imagePath.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(100.0),
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: imagePathViewModel.imagePath.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Image.network(
                                        imagePathViewModel.imagePath[index]),
                                  );
                                },
                              ),
                      ),
                      Text("브랜드: ${snapshot.data!.brand}"),
                      Text("모델명: ${snapshot.data!.model}"),
                      Text("가격: ${snapshot.data!.price}"),
                    ],
                  );
                } else {
                  return Container();
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

  /// Desc : 신발 이미지 가져오기
  /// Date : 2023.03.19
  /// Author : youngjin
  /// *** 이미지 프리뷰 너무 오래 걸림 (수정 필요할 듯) ***
  Future<void> getImageURL(List<String> path) async {
    List<String> pathList = [];
    for (int i = 0; i < path.length; i++) {
      var downloadURL = await FirebaseStorage.instance
          .ref('신발 이미지')
          .child(path[i].substring(8))
          .getDownloadURL();
      // setState(() {
      pathList.add(downloadURL.toString());
      // });
    }
    if (mounted) {
      setState(() {
        imagePathViewModel = ImagePathViewModel(imagePath: pathList);
      });
    }
  }
}
