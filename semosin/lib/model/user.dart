import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semosin/view/cart.dart';

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
  final String initdate;
  final String updatedate;
  final String deletedate;
  final Map<String, Order> orders;
  final List<Cart> carts;
  final List<String> favorites;
}
