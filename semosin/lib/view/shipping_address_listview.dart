import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/view/pay_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart.dart';

class ShippingAddressListview extends StatefulWidget {
  const ShippingAddressListview({super.key, required this.cartList});
  final List<Cart> cartList;

  @override
  State<ShippingAddressListview> createState() =>
      _ShippingAddressListviewState();
}

class _ShippingAddressListviewState extends State<ShippingAddressListview> {
  FirestorePay firestorePay = FirestorePay();
  int selectedIndex = 0;
  late bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: FutureBuilder(
                future: firestorePay.getAllShippingAddress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flex(
                      direction: Axis.vertical,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 700),
                          padding: const EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height / 1.4,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Hero(
                                    tag: 'btn${index}',
                                    createRectTween: (begin, end) {
                                      return RectTween(begin: begin, end: end);
                                    },
                                    child: Material(
                                      color: const Color.fromARGB(
                                          255, 245, 239, 221),
                                      elevation: selectedIndex == index ? 5 : 1,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: selectedIndex == index
                                                  ? 2
                                                  : 1,
                                              color: selectedIndex == index
                                                  ? const Color.fromARGB(
                                                      255, 29, 78, 255)
                                                  : Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${snapshot.data![index].address}, ${snapshot.data![index].addressDetail}',
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                snapshot.data![index].phone,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                if (selectedIndex == 0) {
                                  // 기본 배송지일 경우
                                  setState(() {
                                    setDocumentId('');
                                  });
                                } else {
                                  // 다른 배송지일 경우
                                  setState(() {
                                    setDocumentId(snapshot
                                        .data![selectedIndex].documentId
                                        .toString());
                                  });
                                }
                                Navigator.of(context).pop();
                              },
                              child: const Text('주소 선택')),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      )),
    );
  }

  /// Desc : 선택한 배송지를 앞으로 기본 배송지로 설정
  /// Date : 2023.03.26
  /// Author : youngjin
  setDocumentId(String docId) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('addressId', docId);
  }
}
