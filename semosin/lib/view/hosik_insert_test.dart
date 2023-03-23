import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_insert.dart';
import 'package:semosin/services/firestore_select.dart';

import '../model/cart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

/// 1. User UID 가져오기 /
/// 2. Carts로 insert 하기
///  2 - 1. image0
///  2 - 2. price 추가하기
/// 3. select 하기
/// 4. update??, delete 하기
///
///
/// checkbox의 value 는 firebase cartStatus,
/// default = true, checkbox false시 firebase cartStatus 도 false변환 = update
/// checkbox == true 시 하단에 totalPrice ,
/// 어떤 index가 true인지 알아야함
/// checkbox

class _CartViewState extends State<CartView> {
  late FireStoreSelect fireStoreSelect;
  // late String uid;
  late List lenghtList;
  // late int checkNumber = 0;

  bool cartStatus = true;
  String modelName = 'modelName123';
  String brandName = 'brandName123';
  String size = 'size123';
  String amount = '33';
  String price = '30200';
  String shoesimage =
      'https://firebasestorage.googleapis.com/v0/b/saemosin.appspot.com/o/%EC%8B%A0%EB%B0%9C%20%EC%9D%B4%EB%AF%B8%EC%A7%80%2Fnike%2F%EB%82%98%EC%9D%B4%ED%82%A4-%EB%82%98%EC%9D%B4%ED%82%A4%20%EB%8B%A4%EC%9D%B4%EB%82%98%EB%AA%A8%20%EA%B3%A0%20SE%20%EB%B3%B4%EC%9D%B4%ED%94%84%EB%A6%AC%EC%8A%A4%EC%BF%A8-1.jpg?alt=media&token=42573b01-d4ee-4faf-addb-7a4f5dc89dc3';
  String color = 'red';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireStoreSelect = FireStoreSelect();
    // getUserUID();
    fireStoreSelect.selectCart();
    lenghtList = [];
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 3, 10),
            child: SizedBox(
              width: mq.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // test1();
                        insertCart(cartStatus, modelName, brandName, size,
                            amount, price, color, shoesimage);
                      });
                    },
                    child: const Text(
                      'data',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        insertCart(cartStatus, modelName, brandName, size,
                            amount, price, color, shoesimage);
                      });
                    },
                    child: const Text(
                      'data',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fireStoreSelect.selectCart(),
              builder: (context, snapshot) {
                // for (int i = 0; i < snapshot.data!.length; i++) {
                //   if (lenghtList.length != snapshot.data!.length ||
                //       snapshot.data![index].cartStatus == true) {
                //     lenghtList.add(1);
                //   } else {
                //     lenghtList.add(0);
                //   }
                //   // if (snapshot.data![index].cartStatus) {
                //   //   lenghtList.add(0);
                //   // } else {
                //   //   lenghtList.add(1);
                //   // }
                //   lenghtList.add(1);
                //   print(lenghtList);
                // }

                if (snapshot.hasData) {
                  // ListView builder Start ------
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      /// make :hosik
                      /// 아직 사용할지 말지 확정 아님 필요하게 되면 쓸 배열 하나 생성
                      print('lengh = ${snapshot.data!.length}');
                      // for (int i = 0; i < snapshot.data!.length; i++) {
                      //   if (lenghtList.length != snapshot.data!.length ||
                      //       snapshot.data![i].cartStatus == true) {
                      //     lenghtList.add(1);
                      //   } else {
                      //     lenghtList.add(0);
                      //   }
                      // if (snapshot.data![index].cartStatus) {
                      //   lenghtList.add(0);
                      // } else {
                      //   lenghtList.add(1);
                      // }
                      // lenghtList.add(1);
                      print(lenghtList);
                      // }
                      return Card(
                        child: Row(
                          // -------- check box------
                          children: [
                            snapshot.data![index].cartStatus
                                ? Checkbox(
                                    value: snapshot.data![index].cartStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        // lenghtList[index] -= 1;
                                        print(lenghtList);
                                        snapshot.data![index].cartStatus =
                                            value!;
                                        updateCart(
                                            snapshot.data![index].documentId,
                                            snapshot.data![index].cartStatus,
                                            modelName,
                                            brandName,
                                            size,
                                            snapshot.data![index].amount,
                                            price,
                                            color,
                                            shoesimage);
                                      });
                                    })
                                : Checkbox(
                                    value: snapshot.data![index].cartStatus,
                                    onChanged: (value) {
                                      // lenghtList[index] += 1;
                                      print(lenghtList);
                                      setState(() {
                                        snapshot.data![index].cartStatus =
                                            value!;
                                        updateCart(
                                            snapshot.data![index].documentId,
                                            snapshot.data![index].cartStatus,
                                            modelName,
                                            brandName,
                                            size,
                                            snapshot.data![index].amount,
                                            price,
                                            color,
                                            shoesimage);
                                      });
                                    }),
                            Row(
                              // -------- content in Card------
                              children: [
                                Image.network(
                                  snapshot.data![index].image,
                                  width: mq.width * 0.3,
                                ),
                                Column(
                                  children: [
                                    Text(snapshot.data![index].documentId),
                                    Text(snapshot.data![index].brandName),
                                    Text(snapshot.data![index].modelName),
                                    Row(
                                      children: [
                                        Text(snapshot.data![index].color),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            snapshot.data![index].selectedSize),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text((int.parse(snapshot
                                                    .data![index].price) *
                                                int.parse(snapshot
                                                    .data![index].amount))
                                            .toString()),
                                        ElevatedButton(
                                          child: const Text('-'),
                                          onPressed: () {
                                            setState(() {
                                              snapshot.data![index].amount =
                                                  (int.parse(snapshot
                                                              .data![index]
                                                              .amount) -
                                                          1)
                                                      .toString();
                                              updateCart(
                                                  snapshot
                                                      .data![index].documentId,
                                                  snapshot
                                                      .data![index].cartStatus,
                                                  modelName,
                                                  brandName,
                                                  size,
                                                  snapshot.data![index].amount,
                                                  price,
                                                  color,
                                                  shoesimage);
                                            });
                                          },
                                        ),
                                        Text(snapshot.data![index].amount),
                                        ElevatedButton(
                                          child: const Text('+'),
                                          onPressed: () {
                                            setState(() {
                                              snapshot.data![index].amount =
                                                  (int.parse(snapshot
                                                              .data![index]
                                                              .amount) +
                                                          1)
                                                      .toString();
                                              updateCart(
                                                  snapshot
                                                      .data![index].documentId,
                                                  snapshot
                                                      .data![index].cartStatus,
                                                  modelName,
                                                  brandName,
                                                  size,
                                                  snapshot.data![index].amount,
                                                  price,
                                                  color,
                                                  shoesimage);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ),
          ),
          // ------- Total Price
          Container(
            color: Colors.amber,
            height: 100,
            child: Column(
              children: [
                Text('test'),
              ],
            ),
          ),
        ],
      ),
    ); //여기서부터 지우면 됨
  }

// hosik get User UID
  // Future<String> getUserUID() async {
  //   var users = await fireStoreSelect.getUserInfo();
  //   uid = users.uid;
  //   return uid;
  // }

  Future<void> insertCart(cartStatus, modelName, brandName, size, amount, price,
      color, shoesimage) async {
    FireStoreInsert firestoreinsert = FireStoreInsert();
    firestoreinsert.insertCart(cartStatus, modelName, brandName, size, amount,
        price, color, shoesimage);
  }

  Future<void> updateCart(documentId, cartStatus, modelName, brandName, size,
      amount, price, color, shoesimage) async {
    FireStoreInsert firestoreinsert = FireStoreInsert();
    firestoreinsert.updateCart(documentId, cartStatus, modelName, brandName,
        size, amount, price, color, shoesimage);
  }

  // Cartlist의
}
