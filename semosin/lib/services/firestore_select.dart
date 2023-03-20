import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:semosin/view_model/shoe_view_model.dart';

import '../model/shoe.dart';

class FireStoreSelect {
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 shoes data다 가지고 오기
  Future<List<ShoeViewModel>> selectShoes() async {
    List<ShoeViewModel> shoeViewModelList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shoes').get();
    for (var document in querySnapshot.docs) {
      ShoeViewModel shoeViewModel =
          ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
      shoeViewModelList.add(shoeViewModel);
    }
    return shoeViewModelList;
  }

  /*
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 user data다 가지고 오기
  Future<User> selectUser() async {
    // shared preference 에서 사용자 정보값 가져오기
  }

    return doc.docs.isNotEmpty;
  }
  */
}
