import 'package:flutter/material.dart';
import 'package:semosin/main.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/widget/myappbar.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  IconData? iconData; // 아이콘
  String? status; // 현재 진행상태
  int? counts; // 제품수량
  String clickStatus = "전체"; // 선택한 배송 진행상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "주문현황"),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // 스크롤 안되게
        child: Column(
          children: [
            // 배송현황 ----------------------------------------------------
            orderStatuss(),
            // 날짜 -------------------------------------------------------------
            orderDate(),
            // listview---------------------------------------------------------
            SizedBox(
              height: 640,
              width: 360,
              child: orderListView(),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------Widget----------------------------------

  // 배송현황 정리한 위젯
  Widget orderStatuss() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 9,
            child: orderStatus(
              iconData: Icons.flutter_dash_outlined,
              status: "전체",
              counts: 9,
            ),
          ),
          const Expanded(flex: 3, child: Icon(Icons.arrow_forward)),
          Expanded(
            flex: 9,
            child: orderStatus(
              iconData: Icons.receipt_long_outlined,
              status: "주문확인",
              counts: 3,
            ),
          ),
          const Expanded(flex: 3, child: Icon(Icons.arrow_forward)),
          Expanded(
            flex: 9,
            child: orderStatus(
              iconData: Icons.local_shipping_outlined,
              status: "배송중",
              counts: 3,
            ),
          ),
          const Expanded(flex: 3, child: Icon(Icons.arrow_forward)),
          Expanded(
            flex: 9,
            child: orderStatus(
              iconData: Icons.home_outlined,
              status: "배송완료",
              counts: 99,
            ),
          ),
        ],
      ),
    );
  }

  // 배송현황 위젯
  Widget orderStatus(
      {required IconData iconData,
      required String status,
      required int counts}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          clickStatus = status;
        });
      },
      child: Container(
        width: 75.0,
        height: 75.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: clickStatus == status
              ? const Color.fromARGB(133, 73, 73, 73)
              : const Color.fromARGB(255, 221, 221, 221),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 22.0,
            ),
            const SizedBox(height: 3.0),
            Text(
              status,
              style: const TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 3.0),
            SizedBox(
              width: 17,
              height: 17,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  counts.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 날짜 위젯
  Widget orderDate() {
    return Container(
      width: 360,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20),
                child: Text(
                  "2023.3.22",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                clickStatus,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // 배송완료일때만 삭제버튼
          clickStatus == "배송완료"
              ? Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: GestureDetector(
                    onTap: () {
                      //
                    },
                    child: const Text(
                      "X",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const Text("")
        ],
      ),
    );
  }

// 제품 리스트 위젯
  Widget orderListView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.all(5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: const Color.fromARGB(255, 241, 241, 241),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Image.asset("images/converse.png"),
                ),
              ),
              // -------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "converse",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Chuck 70's",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "90,000원",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              // 버튼 / 수량 -----------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            //
                          },
                          child: const Text(
                            "주문취소",
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              "2",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
