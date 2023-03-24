import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:semosin/model/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestorePay {
  /// Desc : Pay View -> Delivery Request Card에서 '배송시 요청사항' 추가하는 query
  /// Date : 2023.03.24
  /// Author : youngjin
  addDeliveryRequest(String request) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance.collection('users').doc(email).update({
      'deliveryRequest': request,
    });
  }

  /// Desc : Pay View에 배송시 요청사항 보여주기
  /// Date : 2023.03.24
  /// Author : youngjin
  Future<String> getDeliveryRequest() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    String result = '';
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (querySnapshot.data()!.containsKey('deliveryRequest')) {
        result = querySnapshot.data()!['deliveryRequest'];
      }
    } catch (e) {
      rethrow;
    }
    return result;
  }

  /// Desc : Pay View에 구매할 (장바구니에서 가져온) 상품 정보 보여주기
  /// cartStatus, modelName, brandName, size, amount, price, color, shoesimage
  /// Date : 2023.03.24
  /// Author : youngjin
  Future<Cart> getOrderSheet(documentId) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('carts')
          .where(FieldPath.documentId, isEqualTo: documentId)
          .get();

      Map<String, dynamic> data =
          querySnapshot.docs[0].data() as Map<String, dynamic>;
      Cart cart = Cart.fromJson(data);
      return cart;
    } catch (e) {
      rethrow;
    }
  }
}
