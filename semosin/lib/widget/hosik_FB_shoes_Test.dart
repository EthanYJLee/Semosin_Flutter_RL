// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:semosin/view_model/shoe_view_model.dart';

// Widget shoeslist(BuildContext context) {
//   return Center(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('student')
//               .orderBy('code', descending: false)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             final documents = snapshot.data!.docs;
//             return ListView(
//               children: documents.map((e) => _buildItemWidget(e)).toList(),
//             );
//           }));
// }

// // --------------------------------------------------------------------------------
// Widget _buildItemWidget(DocumentSnapshot doc) {
//   final shoes = ShoeViewModel(
//       shoeImageName: doc['Images'],
//       shoeModelName: doc['model'],
//       shoeBrandName: doc['brand'],
//       isLike: doc['phone'],
//       shoePrice: doc['phone']);

//   return Dismissible(
//     direction: DismissDirection.endToStart,
//     background: Container(
//       color: Colors.red,
//       alignment: Alignment.centerRight,
//       child: const Icon(Icons.delete_forever),
//     ),
//     key: ValueKey(doc),
//     onDismissed: (direction) {
//       FirebaseFirestore.instance.collection('students').doc(doc.id).delete();
//     },
//     child: Container(
//       color: Colors.amberAccent,
//       child: GestureDetector(
//         onTap: () {
//           Message.id = doc.id; // key값 하나씩은 무조건 있어야 함
//           Message.code = doc['code'];
//           Message.name = doc['name'];
//           Message.dept = doc['dept'];
//           Message.phone = doc['phone'];
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const Update(),
//               // firebase 는 then 같은거 할 필요없이 그냥 가면 됨. 뒤에가 걍 살아 있는 상태임
//             ),
//           );
//         },
//         child: Card(
//           child: ListTile(
//             title: Text(
//                 '학번 : ${student.code} \n이름 : ${student.name}\n학과 : ${student.dept}\n전화번호 : ${student.phone}'),
//           ),
//         ),
//       ),
//     ),
//   );
// }
