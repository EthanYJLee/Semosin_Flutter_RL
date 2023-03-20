import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:semosin/model/selected_shoe.dart';
import 'package:semosin/view_model/image_path_view_model.dart';

class ShoesInfo {
  /// Desc : ShoesList에서 선택한 신발의 상세정보 ShoeDetail에 출력
  /// Date : 2023.03.18
  /// Author : youngjin
  Future<SelectedShoe> selectModelNameData(String modelName) async {
    String _modelName = modelName;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shoes')
        .where('model', isEqualTo: _modelName)
        .get();

    Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;

    SelectedShoe _selectedShoe = SelectedShoe.fromJson(data);

    return _selectedShoe;
  }
}
