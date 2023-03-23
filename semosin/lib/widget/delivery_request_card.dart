import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DeliveryRequestCard extends StatefulWidget {
  const DeliveryRequestCard({super.key});

  @override
  State<DeliveryRequestCard> createState() => _DeliveryRequestCardState();
}

class _DeliveryRequestCardState extends State<DeliveryRequestCard> {
  late TextEditingController requestController = TextEditingController();

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
                height: 400,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: requestController,
                        decoration: InputDecoration(helperText: '배송 요청사항'),
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('입력'))
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
