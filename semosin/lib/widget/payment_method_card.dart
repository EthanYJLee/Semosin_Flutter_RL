import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PaymentMethodCard extends StatefulWidget {
  const PaymentMethodCard({super.key});

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Hero(
            tag: '',
            createRectTween: (begin, end) {
              return RectTween(begin: begin, end: end);
            },
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '결제수단 선택',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListBody(
                        children: [
                          ListTile(
                            leading: const Text('신용/체크카드'),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          ListTile(
                            leading: const Text('Payco'),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          ListTile(
                            leading: const Text('휴대폰결제'),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          ListTile(
                            leading: const Text('카카오페이'),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('선택'))
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
}
