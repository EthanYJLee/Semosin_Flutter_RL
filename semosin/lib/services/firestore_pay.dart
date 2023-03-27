import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:semosin/model/cart.dart';
import 'package:semosin/model/shipping_address_model.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firestore_insert.dart';
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
  addShippingAddress(name, phone, postcode, address, addressDetail) async {
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
      'addressDetail': addressDetail
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
      Map<String, dynamic> data =
          myAddress.docs[0].data() as Map<String, dynamic>;
      ShippingAddressModel myAddressModel = ShippingAddressModel.fromJson(data);

      shippingAddressModelList.add(myAddressModel);

      // 2. 추가한 주소 가져오기
      QuerySnapshot newAddress = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('shippingAddresses')
          .get();
      for (var document in newAddress.docs) {
        Map<String, dynamic> newData = document.data() as Map<String, dynamic>;
        newData['documentId'] = document.id;
        ShippingAddressModel newShippingAddressModel =
            ShippingAddressModel.fromJson(newData);

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

  /// Desc : 결제 화면으로 처음 이동 시 회원정보에서 내 주소 정보 가져오기
  /// Date : 2023.03.25
  /// Author : youngjin
  // Future<ShippingAddressModel> getMyAddress() async {
  //   final pref = await SharedPreferences.getInstance();
  //   String? email = pref.getString('saemosinemail');
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: email)
  //         .get();

  //     Map<String, dynamic> data =
  //         querySnapshot.docs[0].data() as Map<String, dynamic>;
  //     data['documentId'] = querySnapshot.docs[0].id;
  //     ShippingAddressModel myAddress = ShippingAddressModel.fromJson(data);
  //     return myAddress;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Desc : 배송지 목록 조회 후 결제 페이지로 되돌아갈 시 선택한 배송지 정보 가져오기
  /// Date : 2023.03.25
  /// Author : youngjin
  Future<ShippingAddressModel> getSelectedAddress() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    String documentId = await getDocumentId();
    // print(documentId == '');
    try {
      if (documentId == '') {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        Map<String, dynamic> data =
            querySnapshot.docs[0].data() as Map<String, dynamic>;
        data['documentId'] = querySnapshot.docs[0].id;
        ShippingAddressModel myAddress = ShippingAddressModel.fromJson(data);
        // print(myAddress);
        return myAddress;
      } else {
        DocumentSnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(email)
                .collection('shippingAddresses')
                .doc(documentId)
                .get();

        Map<String, dynamic>? newData = querySnapshot.data();

        newData!['documentId'] = documentId;
        ShippingAddressModel newAddress =
            ShippingAddressModel.fromJson(newData);
        return newAddress;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Desc : 설정한 배송지의 documentId (없으면 기본 주소) 가져오기
  /// Date : 2023.03.26
  /// Author : youngjin
  Future<String> getDocumentId() async {
    final pref = await SharedPreferences.getInstance();
    String docId = pref.getString('addressId') ?? "";
    return docId;
  }

  setPurchaseOrders(name, phone, postcode, address, addressDetail,
      deliveryRequest, orderModel, orderedSize, amount) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('orders')
        .doc()
        .set({
      'name': name,
      'phone': phone,
      'postcode': postcode,
      'address': address,
      'addressDetail': addressDetail,
      'deliveryRequest': deliveryRequest,
      'orderModel': orderModel,
      'orderedSize': orderedSize,
      'amount': amount,
      'orderDate': DateTime.now().toString(),
      // 1: 접수중; 2: 배송중; 3: 배송완료; 4: 배송완료 후 숨기기
      'orderStatus': 1,
      // 1: 취소미신청; 2: 취소신청중; 3: 취소신청완료; 4: 취소신청취소
      'cancelStatus': 1,
      // 'cancelNo': cancelNo,
      // 1: 환불미신청; 2: 환불신청중; 3: 환불신청완료; 4: 환불신청취소
      'refundStatus': 1,
      // 'refundNo': refundNo,
      // 1: 교환미신청; 2: 교환신청중; 3: 교환신청완료; 4: 교환신청취소
      'exchangeStatus': 1,
      // 'exchangeNo': exchangeNo,
      'changeStatusDate': DateTime.now().toString(),
      // 'changeStatusDoneDate': changeStatusDoneDate,
    });
  }
}
