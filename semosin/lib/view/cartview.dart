import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/view/pay_view.dart';
import '../services/firebase_delete.dart';
import 'package:intl/intl.dart';
import '../services/firestore_insert.dart';
import '../services/firestore_select.dart';
import '../model/cart.dart';

//   /// 날짜 :2023.03.20
//   /// 만든이 : 이호식
//   /// 내용 : Cart
class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late FireStoreSelect fireStoreSelect;
  late int totalPrice;
  // 가격 문자열 포맷팅 -----------
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0);
  // ---------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectCart();
    calcTotalPrice();
    totalPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 3, 10),
            child: SizedBox(
              width: mq.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => checkBoxValueChange(true),
                    child: const Text(
                      '전체선택',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => checkBoxValueChange(false),
                    child: const Text(
                      '전체해제',
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
                  // ListView builder Start ------
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      List snapshotList = [
                        snapshot.data![index].documentId,
                        snapshot.data![index].cartStatus,
                        snapshot.data![index].modelName,
                        snapshot.data![index].brandName,
                        snapshot.data![index].selectedSize,
                        snapshot.data![index].amount,
                        snapshot.data![index].price,
                        snapshot.data![index].image,
                        snapshot.data![index].shoesAmount
                      ];
                      return Dismissible(
                        key: ValueKey(snapshot),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection dir) async {
                          deleteCart(snapshotList[0]);
                        },
                        confirmDismiss: (DismissDirection dir) async =>
                            dir == DismissDirection.endToStart,
                        background: Container(),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        child: Card(
                          child: Row(
                            // -------- check box Start ------
                            children: [
                              Column(
                                children: [
                                  Checkbox(
                                      value: snapshotList[1],
                                      onChanged: (value) {
                                        setState(() {
                                          snapshotList[1] = value!;
                                          updateSetCart(snapshotList);
                                        });
                                        calcTotalPrice();
                                      }),
                                ],
                              ),
                              // -------- check box END ------
                              Column(
                                children: [
                                  //  -------- Image --------
                                  Column(
                                    children: [
                                      Image.network(
                                        snapshot.data![index].image,
                                        width: mq.width * 0.3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //  -------- Image END --------
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${snapshotList[3]}\n${snapshotList[2]}'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text(snapshotList[4]),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Minus Button
                                        AmountButton(
                                            context, '-', snapshotList),
                                        // Amount
                                        Text(snapshotList[5]),
                                        // Plus Button
                                        AmountButton(
                                            context, '+', snapshotList),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  // } else if (snapshot.hasData.itemCount == 0) {
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ),
          ),
          // ------- Total Price
          Container(
            width: mq.width,
            color: Colors.grey[400],
            child: Column(
              children: [
                SizedBox(
                  width: mq.width * 0.8,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Total Price : ${formatCurrency.format(totalPrice)}원'),
                      ElevatedButton(
                        onPressed: () async {
                          /// Desc : 'carts' collection에서 cartStatus가 True인 것만 불러와서 List<Cart>에 담아 PayView로 보냄
                          /// FirestorePay
                          /// Date : 2023.03.25
                          /// Author : youngjin
                          FirestorePay firestorePay = FirestorePay();
                          List<Cart> cartList = await firestorePay.cartToPay();
                          if (cartList.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Column(
                                children: const [
                                  SizedBox(
                                      height: 15,
                                      child: Text(
                                        '상품을 선택해주십시오',
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),
                              dismissDirection: DismissDirection.up,
                              duration: const Duration(milliseconds: 500),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PayView(
                                      cartModelList: cartList,
                                    )));
                          }
                          //PayView
                        },
                        child: const Text(
                          '구매하러 가기 ',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------ Widget ----------------------------------------------------------------------

  // 수량조절 +,- Button
  Widget AmountButton(BuildContext context, String state, List list) {
    Icon removeButton = const Icon(Icons.remove_circle);
    Icon addButton = const Icon(Icons.add_circle);
    return IconButton(
      onPressed: () {
        setState(() {
          list[5] = underZeroLimitMaximum(state, list[5], list[8]);
          updateSetCart(list);
          calcTotalPrice();
        });
      },
      icon: state == '-' ? removeButton : addButton,
    );
  } //Widget minusButton END

  // ------ Widget End ------------------------------------------------------------------

// ------ Funtion ------------------------------------------------------------------

  // Future
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
      setState(() {
        totalPrice = result;
      });
    }
    // return result;
  }

  // 임시 Insert
  Future<void> insertCart(
      cartStatus, modelName, brandName, size, amount, price, shoesimage) async {
    FireStoreInsert fireStoreInsert = FireStoreInsert();
    fireStoreInsert.insertCart(
        cartStatus, modelName, brandName, size, amount, price, shoesimage);
  }

  // CheckBox 전체 선택/해제
  checkBoxValueChange(bool checkState) async {
    List<Cart> checkBoxValueChangeList = await fireStoreSelect.selectCart();
    int i = 0;
    while (true) {
      String documentId = checkBoxValueChangeList[i].documentId;

      FireStoreInsert fireStoreInsert = FireStoreInsert();
      fireStoreInsert.stateCart(documentId, checkState);
      i++;
      if (i >= checkBoxValueChangeList.length) {
        break;
      }
      setState(() {
        if (checkState) {
          calcTotalPrice();
        } else {
          totalPrice = 0;
        }
      });
    } //checkBoxValueChangeEND
  }

  //Update
  Future<void> updateSetCart(List list) async {
    FireStoreInsert fireStoreInsert = FireStoreInsert();
    fireStoreInsert.updateCart(list[0], list[1], list[2], list[3], list[4],
        list[5], list[6], list[7], list[8]);
  }

  //Delete
  void deleteCart(documentId) async {
    FireStoreDelete delete = FireStoreDelete();
    delete.deleteCart(documentId);
    setState(() {});
    calcTotalPrice();
    // setState(() {});
  }

// 주문수량이 0미만 이거나 최대 수량을 넘어설 시 나오는 Alert Function  - 1
// Firebase에서 받아온 현재 amount의 갯수와 +,- 버튼 클릭시 실행하는 함수
  underZeroLimitMaximum(String state, String getNowAmount, int shoesAmount) {
    // 받아온 getNowAmount는 firebase에서 string으로 관리되어서 계산이 편하도록 int로 변환
    int _amount = int.parse(getNowAmount);
    setState(() {
      // + 버튼 클릭시
      if (state == '+') {
        _amount++;
        if (_amount > shoesAmount) {
          showAmountDialog('plus');
          _amount = shoesAmount;
        }
      } else {
        // - 버튼 클릭시
        _amount--;
        if (_amount < 1) {
          showAmountDialog('minus');
          _amount = 1;
        }
      }
    });
    // return시 string값으로 반환하기 위해 toString
    // String retrunResult = _amount.toString();
    return _amount.toString();

    // return retrunResult;
  }

// 주문수량이 0미만 이거나 최대 수량을 넘어설 시 나오는 Alert Function  - 2
// 1에서 조건에 맞을 시 +,-에 맞는 alert가 나오게 만드는 함수
  showAmountDialog(String status) {
    if (status == 'plus') {
      alertDialogAmount('재고보다 많이 구매하실 수 없습니다');
    } else {
      alertDialogAmount('1개 미만으로 고르실 수 없습니다.');
    }
  }

// 주문수량이 0미만 이거나 최대 수량을 넘어설 시 나오는 Alert Function  - 3
// 주문수량이 0미만 이거나 최대 수량을 넘어설 시 나오는 Alert Function
  alertDialogAmount(comment) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              '수량 확인',
            ),
            content: Text(
              comment,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }
}
