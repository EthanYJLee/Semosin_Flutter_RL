// import 'package:flutter/material.dart';
// import 'package:semosin/services/firestore_select.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CartView extends StatefulWidget {
//   const CartView({super.key});

//   @override
//   State<CartView> createState() => _CartViewState();
// }

// class _CartViewState extends State<CartView> {
//   late String userId;
//   late String userPw;
//   late String prefEmail;
//   late FireStoreSelect fireStoreSelect;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     userId = "";
//     userPw = '';
//     prefEmail = '';
//     // _initSharedPreferences();
//     fireStoreSelect = FireStoreSelect();
//     fireStoreSelect.selectFavoriteShoes();
//     fireStoreSelect.getUserInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Cart Test by Hosik',
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       //
//                     },
//                     child: const Text(
//                       '전체 선택',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       //
//                     },
//                     child: const Text(
//                       '전체 해제',
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Text()
//           ],
//         ),
//       ),
//     );
//   }

//   // /// ----------

//   // Future test() async {
//   //   list = await FirebaseUser();
//   //   return list;
//   // }

//   // selectString() {
//   //   final pref = SharedPreferences.getInstance();
//   //   var result = pref.geteamil.getString(email) ?? "test";
//   //   return result;
//   // }

//   _initSharedPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefEmail = prefs.getString("saemosinemail")!;
//     });
//     return prefEmail;
//   } //  _initSharedPreferences END

// } // END
