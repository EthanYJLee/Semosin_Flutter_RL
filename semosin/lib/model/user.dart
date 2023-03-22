import 'package:semosin/model/cart.dart';
import 'package:semosin/model/order.dart';

class User {
  final String name;
  final String uid;
  final String email;
  final String nickname;
  final String sex;
  final String phone;
  final String address;
  final String addressDetail;
  final String postcode;
  // final String initdate;
  // final String updatedate;
  // final String deletedate;
  // final List<Order> orders;
  // final List<Cart> carts;

  User({
    required this.name,
    required this.uid,
    required this.email,
    required this.nickname,
    required this.sex,
    required this.phone,
    required this.address,
    required this.addressDetail,
    required this.postcode,
    // required this.initdate,
    // required this.updatedate,
    // required this.deletedate,
    // required this.orders,
    // required this.carts,
  });

  User.fromJson(Map<String, dynamic> json) //* = db에 있는 것
      : name = json['name'].toString(), //*
        uid = json['uid'].toString(), //*
        email = json['email'].toString(), //*
        nickname = json['nickname'].toString(), //*
        sex = json['sex'].toString(), //*
        phone = json['phone'].toString(), //*
        address = json['address'].toString(), //*
        addressDetail = json['addressDetail'].toString(), //*
        postcode = json['postcode']; //*
  // initdate = json['initdate'].toString(),
  // updatedate = json['updatedate'].toString(),
  // deletedate = json['deletedate'].toString(),
  // orders = json['orders'].map((e) => Order.fromJson(e)).toList(),
  // carts = json['carts'].map((e) => Cart.fromJson(e)).toList();
}
