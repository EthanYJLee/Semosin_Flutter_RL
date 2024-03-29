import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semosin/model/shoe.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

String datetime = DateTime.now().toString();

class FireStoreInsert {
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : model 이름 firestore user favorites에 넣기
  insertFavorite(modelName, brandName, image, price) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('favorites')
        .doc(modelName)
        .set({
      'model': modelName,
      'brand': brandName,
      'image': image,
      'price': price,
      'initdate': DateTime.now().toString().substring(0, 19),
    });
  }

  /// 날짜 :2023.03.22
  /// 만든이 : 이호식
  /// 내용 : Firebase Carts Insert
  insertCart(
      cartStatus, modelName, brandName, size, amount, price, shoesimage) async {
    final pref = await SharedPreferences.getInstance();
    String testSize = size.toString();
    String? email = pref.getString('saemosinemail');
    FireStoreSelect getShoesAmount = FireStoreSelect();
    Shoe map = await getShoesAmount.selectModelNameData(modelName);
    int shoesAmount = int.parse(map.sizes[testSize].toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('carts')
        .doc()
        .set({
      'cartStatus': cartStatus,
      'selectedSize': size,
      'brandName': brandName,
      'modelName': modelName,
      'amount': amount,
      'initDate': datetime.substring(0, 10),
      'price': price,
      'image': shoesimage,
      'shoesAmount': shoesAmount,
    });
  } //insertCart END

  updateCart(documentId, cartStatus, modelName, brandName, size, amount, price,
      shoesimage, shoesAmount) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('carts')
        .doc(documentId)
        .set({
      'cartStatus': cartStatus,
      'selectedSize': size,
      'brandName': brandName,
      'modelName': modelName,
      'amount': amount,
      'initDate': datetime.substring(0, 10),
      'price': price,
      'image': shoesimage,
      'shoesAmount': shoesAmount,
    });
  } //updateCart END

//just update cartsate
  stateCart(documentId, cartStatus) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('carts')
        .doc(documentId)
        .update({
      'cartStatus': cartStatus,
    });
  } //updateCart END
}
