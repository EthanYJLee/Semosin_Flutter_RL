import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:semosin/model/cart.dart';
import 'package:semosin/model/shipping_address_model.dart';
import 'package:semosin/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 결제하기 뷰에서 사용되는 query
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

  /// Desc : 신규 배송지 추가하기
  /// Date : 2023.03.24
  /// Author : youngjin
  addShippingAddress(name, phone, postcode, address, detailAddress) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('shippingAddresses')
        .doc()
        .set({
      'name': name,
      'phone': phone,
      'postcode': postcode,
      'address': address,
      'detailAddress': detailAddress
    });
  }

  /// Desc : 전체 배송지 가져오기 (기본 주소 + 추가한 배송지 주소)
  /// Date : 2023.03.24
  /// Author : youngjin
  Future<List<ShippingAddressModel>> getAllShippingAddress() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    List<ShippingAddressModel> shippingAddressModelList = [];
    try {
      // 1. 기본 주소 가져오기
      QuerySnapshot myAddress = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      Map<String, dynamic> myData =
          myAddress.docs[0].data() as Map<String, dynamic>;

      User userInfo = User.fromJson(myData);
      ShippingAddressModel myAddressModel = ShippingAddressModel(
          name: userInfo.name,
          address: userInfo.address,
          detailAddress: userInfo.addressDetail,
          phone: userInfo.phone);
      shippingAddressModelList.add(myAddressModel);

      // 2. 추가한 주소 가져오기
      QuerySnapshot newAddress = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('shippingAddresses')
          .get();
      for (var document in newAddress.docs) {
        ShippingAddressModel newShippingAddressModel =
            ShippingAddressModel.fromJson(
                document.data() as Map<String, dynamic>);
        shippingAddressModelList.add(newShippingAddressModel);
      }
      return shippingAddressModelList;
    } catch (e) {
      rethrow;
    }
  }

  /// Desc : Cart View에서 체크박스 선택한 상품만 Pay View로 넘기기
  /// Date : 2023.03.25
  /// Author : youngjin
  Future<List<Cart>> cartToPay() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('saemosinemail')!;
    List<Cart> cartList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('carts')
          .where('cartStatus', isEqualTo: true)
          .get();
      for (var document in querySnapshot.docs) {
        Cart cartModel = Cart.fromJson(document.data() as Map<String, dynamic>);
        cartList.add(cartModel);
      }
      return cartList;
    } catch (e) {
      rethrow;
    }
  }
}
