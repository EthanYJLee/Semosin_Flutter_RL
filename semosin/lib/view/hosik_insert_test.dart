import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firestore_insert.dart';
import 'package:semosin/services/firestore_select.dart';

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

class _CartViewState extends State<CartView> {
  late FireStoreSelect fireStoreSelect;
  late String uid;

  String cartNo2 = 'cartNo123';
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
    getUserUID();
    fireStoreSelect.selectCart();
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
                        insertCart(uid, cartNo2, modelName, brandName, size,
                            amount, price, shoesimage, color);
                      });
                    },
                    child: const Text(
                      'data',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // test1();

                        insertCart(uid, cartNo2, modelName, brandName, size,
                            amount, price, shoesimage, color);
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
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Row(
                              children: [const Text('data')],
                            ),
                            Row(
                              children: [
                                Image.network(
                                  snapshot.data![index].image,
                                  width: mq.width * 0.3,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      snapshot.data![index].cartModelName,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].color,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          snapshot.data![index].selectedSize,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data![index].price,
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
        ],
      ),
    ); //여기서부터 지우면 됨
  }

// hosik get User UID
  Future<String> getUserUID() async {
    var users = await fireStoreSelect.getUserInfo();
    uid = users.uid;
    return uid;
  }

  Future<void> insertCart(uid, cartNo2, modelName, brandName, size, amount,
      price, shoesimage, color) async {
    FireStoreInsert firestoreinsert = FireStoreInsert();
    firestoreinsert.insertCart(uid, cartNo2, modelName, brandName, size, amount,
        price, color, shoesimage);
  }
}
