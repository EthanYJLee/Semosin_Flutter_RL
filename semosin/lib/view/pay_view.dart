import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:semosin/model/cart.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/order_status.dart';
import 'package:semosin/view/shipping_address_listview.dart';
import 'package:semosin/view/tabbar.dart';
import 'package:semosin/widget/address_card.dart';
import 'package:semosin/widget/card_dialog.dart';
import 'package:semosin/widget/delivery_request_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayView extends StatefulWidget {
  const PayView({super.key, required this.cartModelList});
  final List<Cart> cartModelList;

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  FireStoreSelect fireStoreSelect = FireStoreSelect();
  FirestorePay firestorePay = FirestorePay();
  int totalPrice = 0;
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0);
  late String docId = '';

  // 주문시 사용
  late String selectedName = '';
  late String selectedPhone = '';
  late String selectedPostcode = '';
  late String selectedAddress = '';
  late String selectedAddressDetail = '';
  late String selectedDeliveryRequest = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 223, 223, 223),
        appBar: AppBar(),
        body: Center(
          // 배송지 정보 (회원가입시 입력했던 주소지) 불러오기 -------------------------------------------
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              deliveryAddressWidget(),
              Container(
                  height: MediaQuery.of(context).size.height / 7.5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      '배송시 요청사항',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ),
                          deliveryRequestWidget(),
                        ],
                      ),
                    ),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height / 7.5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      '결제수단',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('payment ontap');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    '결제수단 선택',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  '주문정보',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: widget.cartModelList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    calcTotalPrice();
                                    return Hero(
                                        tag: 'product$index',
                                        createRectTween: (begin, end) {
                                          return RectTween(
                                              begin: begin, end: end);
                                        },
                                        child: Material(
                                          color: const Color.fromARGB(
                                              218, 212, 214, 241),
                                          elevation: 0.5,
                                          shape: RoundedRectangleBorder(
                                              side:
                                                  const BorderSide(width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${widget.cartModelList[index].brandName}, ${widget.cartModelList[index].modelName}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                            '가격: ${formatCurrency.format(int.parse(widget.cartModelList[index].price))}원'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Text(
                                                            '수량: ${widget.cartModelList[index].amount}'),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  }),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '총 결제금액:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${formatCurrency.format(totalPrice)}원',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      // --------------------------------------------------------
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('주문결정'),
                              content: const Text('선택하신 상품을 구매하시겠습니까?'),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          for (var product
                                              in widget.cartModelList) {
                                            firestorePay.setPurchaseOrders(
                                                selectedName,
                                                selectedPhone,
                                                selectedPostcode,
                                                selectedAddress,
                                                selectedAddressDetail,
                                                selectedDeliveryRequest,
                                                product.modelName,
                                                product.selectedSize,
                                                product.amount);
                                          }
                                          Navigator.of(context).pop();
                                          payCompleted();
                                        },
                                        child: const Text('확인',
                                            style: TextStyle(
                                                color: Colors.black))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('취소',
                                            style:
                                                TextStyle(color: Colors.black)))
                                  ],
                                )
                              ],
                            );
                          });

                      // payCompleted();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('결제하기')),
              )
            ],
          ),
        ));
  }

  // ------------------------------------------ WIDGET ------------------------------------------
  /// Desc : 배송지 정보 (배송지 주소, 우편번호, 휴대폰 번호) 카드 위젯
  /// Date : 2023.03.24
  /// Author : youngjin
  Widget deliveryAddressWidget() {
    // getDocumentId();
    // print(docId);
    return FutureBuilder(
      future: firestorePay.getSelectedAddress(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selectedName = snapshot.data!.name;
          selectedPhone = snapshot.data!.phone;
          selectedPostcode = snapshot.data!.postcode;
          selectedAddress = snapshot.data!.address;
          selectedAddressDetail = snapshot.data!.addressDetail;
          return Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ShippingAddressListview(
                                                      cartList:
                                                          widget.cartModelList,
                                                    )))
                                            .then((_) {
                                          setState(() {
                                            firestorePay.getSelectedAddress();
                                          });
                                        });
                                      },
                                      child: Row(
                                        children: const [
                                          Text('배송지 목록'),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                                CupertinoIcons.list_bullet),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(CardDialog(builder: (context) {
                              return AddressCard(
                                name: snapshot.data!.name,
                                postcode: snapshot.data!.postcode,
                                address: snapshot.data!.address,
                                addressDetail: snapshot.data!.addressDetail,
                              );
                            })).then((_) {
                              // 주소 수정하고 돌아오면 Future함수 재실행
                              setState(() {
                                firestorePay.getSelectedAddress();
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      '휴대폰: ${snapshot.data!.phone}',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 1.2,
          );
        }
      },
    );
  }

  /// Desc : 배송시 요청사항 카드 위젯
  /// Date : 2023.03.24
  /// Author : youngjin
  Widget deliveryRequestWidget() {
    return FutureBuilder(
      future: firestorePay.getDeliveryRequest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selectedDeliveryRequest = snapshot.data!;
          // 1. 입력한 요청사항이 빈 칸이면 ('') 추가 버튼 보여주기
          if (snapshot.data == '') {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(CardDialog(builder: (context) {
                      return const DeliveryRequestCard();
                    })).then((_) {
                      setState(() {
                        firestorePay.getDeliveryRequest();
                      });
                    });
                  },
                  child: Container(
                    child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: const Icon(
                          Icons.add,
                        )),
                  ),
                ),
              ],
            );
          } else {
            // 2. 입력한 요청사항이 있다면 요청사항 보여주기
            return Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(CardDialog(builder: (context) {
                    return const DeliveryRequestCard();
                  })).then((_) {
                    setState(() {
                      firestorePay.getDeliveryRequest();
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot.data!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          // 3. 요청사항 필드가 아예 없어도 추가버튼 보여주기
          return InkWell(
            onTap: () {
              Navigator.of(context).push(CardDialog(builder: (context) {
                return const DeliveryRequestCard();
              }));
            },
            child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.add,
                )),
          );
        }
      },
    );
  }

  /// Desc : 주문완료 Dialog
  payCompleted() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('주문완료'),
            content: const Text('주문이 완료되었습니다'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        // 홈 화면 라우터 설정
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "/home"),
                            builder: (context) => const ShoesTabBar(),
                          ),
                        );
                        // 홈 화면까지 pop
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/home"));
                      },
                      child: const Text(
                        '홈으로',
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        // 홈 화면 라우터 설정
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "/home"),
                            builder: (context) => const ShoesTabBar(),
                          ),
                        );
                        // 홈 화면까지 pop
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/home"));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrderStatus()));
                      },
                      child: const Text('주문현황으로',
                          style: TextStyle(color: Colors.black)))
                ],
              )
            ],
          );
        });
  }

  // ---------------------- FUNCTIONS ----------------------

  /// Desc : 총 결제금액 계산
  /// Date : 2023.03.26
  /// Author : youngjin
  calcTotalPrice() async {
    List<Cart> list = await fireStoreSelect.selectCart();
    int result = 0;
    if (list.isEmpty) {
      totalPrice = 0;
    } else {
      int i = 0;
      totalPrice = 0;
      while (true) {
        if (list[i].cartStatus == true) {
          result += int.parse(list[i].price) * int.parse(list[i].amount);
        }
        i++;
        if (i >= list.length) {
          break;
        }
      }
      if (mounted) {
        setState(() {
          totalPrice = result;
        });
      }
    }
  }

  /// Desc : 결제방법 위젯
  /// Date : 2023.03.26
  /// Author : youngjin
  // Widget setPaymentMethod() {
  //   return Container();
  // }

  /// Desc : 다른 배송지 목록 가져올 때 documentId -> SharedPreferences에서 가져오기 (없으면 기본 주소)
  /// Date : 2023.03.26
  /// Author : youngjin
  getDocumentId() async {
    final pref = await SharedPreferences.getInstance();
    docId = pref.getString('addressId') ?? "";
    // print(docId);
  }
}
