import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firebase_firestore.dart';
import 'package:semosin/view_model/shoe_view_model.dart';

// void cartInsert(String data){

//   FirebaseFirestore.instance.collection('users').
// };
// FirebaseUser() {
//   var db = FirebaseFirestore.instance.collection('users').doc().get();
//   print('<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
//   print(db);
//   print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
//   db.
//   return db;
// }

Future<List<User>> firebaseUser() async {
  List<User> userViewModelList = [];
  var result;
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  for (var document in querySnapshot.docs) {
    User users = User.fromJson(document.data() as Map<String, dynamic>);
    userViewModelList.add(users);
    // print(shoeViewModel.shoeImageName.substring(8));
    // var url = await FirebaseStorage.instance.collection('users').doc().get();
    result = await FirebaseFirestore;
  }
  // print(shoeViewModelList[0].shoeImageName.substring(8));
  print(result);
  return userViewModelList;
}
