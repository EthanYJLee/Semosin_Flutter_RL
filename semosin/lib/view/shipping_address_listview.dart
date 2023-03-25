import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:semosin/services/firestore_pay.dart';

class ShippingAddressListview extends StatefulWidget {
  const ShippingAddressListview({super.key});

  @override
  State<ShippingAddressListview> createState() =>
      _ShippingAddressListviewState();
}

class _ShippingAddressListviewState extends State<ShippingAddressListview> {
  FirestorePay firestorePay = FirestorePay();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          FutureBuilder(
              future: firestorePay.getAllShippingAddress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Hero(
                            tag: 'btn${index}',
                            createRectTween: (begin, end) {
                              return RectTween(begin: begin, end: end);
                            },
                            child: Material(
                              color: const Color.fromARGB(255, 245, 239, 221),
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        snapshot.data![index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${snapshot.data![index].address}, ${snapshot.data![index].detailAddress}',
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data![index].phone,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              })
        ],
      )),
    );
  }
}
