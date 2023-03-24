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
                      height: MediaQuery.of(context).size.height / 5,
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
                              const SizedBox(
                                height: 10,
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
                                          '${snapshot.data!.address}, \n${snapshot.data!.addressDetail}',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          '우편번호: ${snapshot.data!.postcode}',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
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
                                      '배송시 요청사항',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              // 배송시 요청사항 --------------------------------------------------------
                              FutureBuilder(
                                future: firestorePay.getDeliveryRequest(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // 1. 입력한 요청사항이 빈 칸이면 ('') 추가 버튼 보여주기
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
                                                return const DeliveryRequestCard();
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
                                      // 2. 입력한 요청사항이 있다면 요청사항 보여주기
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
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      CardDialog(
                                                          builder: (context) {
                                                    return const DeliveryRequestCard();
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
                                    // 3. 요청사항 필드가 아예 없어도 추가버튼 보여주기
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
                                              return const DeliveryRequestCard();
                                            }));
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                          )),
                                    );
                                  }
                                },
                              ) // 배송시 요청사항 END --------------------------------------------------------
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
                                  children: const [
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
                                    const Text(
                                      '이미지',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Column(
                                      children: const [
                                        Text('상품명'),
                                        Text('가격'),
                                        Text('주문수량')
                                      ],
                                    )
                                  ],
                                ),
                                const Text('총 결제 금액')
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
