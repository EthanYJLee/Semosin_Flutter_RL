import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:semosin/model/selected_shoe.dart';

class ShoesInfo {
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
