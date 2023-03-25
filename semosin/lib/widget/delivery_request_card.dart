import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:semosin/services/firestore_insert.dart';
import 'package:semosin/services/firestore_pay.dart';

class DeliveryRequestCard extends StatefulWidget {
  /// Desc : 구매하기 View에서 배송 요청사항 눌렀을 때 나오는 Popup Card (Default: null, 입력하면 추가됨)
  /// Date : 2023.03.22
  /// Author : youngjin
  const DeliveryRequestCard({super.key});

  @override
  State<DeliveryRequestCard> createState() => _DeliveryRequestCardState();
}

class _DeliveryRequestCardState extends State<DeliveryRequestCard> {
  late TextEditingController requestController = TextEditingController();
  FirestorePay firestorePay = FirestorePay();
  late List<String> requestList = [
    '빠른 배송 부탁드립니다.',
    '배송 전 연락주세요.',
    '부재시 휴대폰으로 연락주세요.',
    '부재시 경비실에 맡겨주세요.',
    '직접 입력',
    '선택 안 함'
  ];
  late String request = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: Hero(
            tag: '',
            createRectTween: (begin, end) {
              return RectTween(begin: begin, end: end);
            },
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '배송시 요청사항',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      // TextField(
                      //   controller: requestController,
                      //   decoration: InputDecoration(helperText: '요청사항을 입력해주세요'),
                      // ),
                      _dropdownArea(),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (requestController.text.trim().length > 20) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Column(
                                  children: const [
                                    SizedBox(
                                        height: 15,
                                        child: Text(
                                          '20자 이내로 입력해주십시오',
                                          textAlign: TextAlign.center,
                                        )),
                                  ],
                                ),
                                dismissDirection: DismissDirection.up,
                                duration: const Duration(milliseconds: 500),
                              ));
                            } else {
                              if (requestController.text == '선택 안 함' ||
                                  requestController.text == '') {
                                firestorePay.addDeliveryRequest('');
                                Navigator.of(context).pop();
                              } else {
                                // ----------------
                                firestorePay.addDeliveryRequest(
                                    requestController.text.trim());
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('입력'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  /// Desc : 배송시 요청사항 선택하는 dropdownarea
  /// Date : 2023.03.24
  /// Author : youngjin
  Widget _dropdownArea() {
    // 요청사항 dropdown list
    final List<DropdownMenuEntry<String>> requestEntries =
        <DropdownMenuEntry<String>>[];
    for (final request in requestList) {
      requestEntries
          .add(DropdownMenuEntry<String>(value: request, label: request));
    }

    return Container(
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          // const SizedBox(
          //   height: 50,
          // ),
          Expanded(
            child: DropdownMenu(
              menuHeight: 300,
              width: MediaQuery.of(context).size.width / 1.5,
              initialSelection: requestList[0],
              controller: requestController,
              label: const Text(
                '요청사항',
                style: TextStyle(color: Colors.black),
              ),
              dropdownMenuEntries: requestEntries,
              onSelected: (value) {
                if (value == '직접 입력') {
                  requestController.text = '';
                }
                request = requestController.text;
              },
            ),
          ),
        ],
      ),
    );
  }
}
