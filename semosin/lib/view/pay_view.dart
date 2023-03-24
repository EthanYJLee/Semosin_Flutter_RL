import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/widget/address_card.dart';
import 'package:semosin/widget/card_dialog.dart';
import 'package:semosin/widget/delivery_request_card.dart';

class PayView extends StatefulWidget {
  const PayView({super.key});

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  FireStoreSelect fireStoreSelect = FireStoreSelect();
  FirestorePay firestorePay = FirestorePay();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: fireStoreSelect.getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(CardDialog(builder: (context) {
                              return AddressCard(
                                postcode: snapshot.data!.postcode,
                                address: snapshot.data!.address,
                                addressDetail: snapshot.data!.addressDetail,
                                phone: snapshot.data!.phone,
                              );
                            })).then((_) {
                              // 주소 수정하고 돌아오면 Future함수 재실행
                              setState(() {
                                fireStoreSelect.getUserInfo();
                              });
                            });
                          },
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        '배송지',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const VerticalDivider(
                                        width: 20,
                                        thickness: 2,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                      Text(
                                        snapshot.data!.name,
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          '${snapshot.data!.address}, ${snapshot.data!.addressDetail}',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          '휴대폰: ${snapshot.data!.phone}',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        color: Colors.white,
                        child: InkWell(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: const [
                                    Text(
                                      '배송 요청사항',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              // deliveryRequest == ''
                              // ? Container(
                              //     height: 40,
                              //     width: 100,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(width: 1),
                              //         borderRadius:
                              //             BorderRadius.circular(10)),
                              //     child: IconButton(
                              //         onPressed: () {
                              //           Navigator.of(context).push(
                              //               CardDialog(builder: (context) {
                              //             return DeliveryRequestCard();
                              //           }));
                              //         },
                              //         icon: const Icon(
                              //           Icons.add,
                              //         )),
                              //   )
                              //     : Text(deliveryRequest)
                              FutureBuilder(
                                future: firestorePay.getDeliveryRequest(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == '') {
                                      return Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  CardDialog(
                                                      builder: (context) {
                                                return DeliveryRequestCard();
                                              })).then((_) {
                                                setState(() {
                                                  firestorePay
                                                      .getDeliveryRequest();
                                                });
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                            )),
                                      );
                                    } else {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                snapshot.data!,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      CardDialog(
                                                          builder: (context) {
                                                    return DeliveryRequestCard();
                                                  })).then((_) {
                                                    setState(() {
                                                      firestorePay
                                                          .getDeliveryRequest();
                                                    });
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.settings,
                                                )),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                CardDialog(builder: (context) {
                                              return DeliveryRequestCard();
                                            }));
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                          )),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        color: Colors.white,
                        child: InkWell(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Text(
                                      '결제수단',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        color: Colors.white,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '최종 결제 금액',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '이미지',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Column(
                                      children: [
                                        Text('상품명'),
                                        Text('가격'),
                                        Text('주문수량')
                                      ],
                                    )
                                  ],
                                ),
                                Text('총 결제 금액')
                              ],
                            ),
                          ),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text('결제하기'))
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
