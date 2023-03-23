import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddressCard extends StatefulWidget {
  const AddressCard(
      {super.key,
      required this.address,
      required this.addressDetail,
      required this.phone});
  final String address;
  final String addressDetail;
  final String phone;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  late TextEditingController addressController;
  late TextEditingController addressDetailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    addressDetailController = TextEditingController();
    addressController.text = widget.address;
    addressDetailController.text = widget.addressDetail;
    phoneController.text = widget.phone;
  }

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
                        controller: addressController,
                        decoration: InputDecoration(helperText: '주소'),
                      ),
                      TextField(
                        controller: addressDetailController,
                        decoration: InputDecoration(helperText: '상세주소'),
                      ),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(helperText: '휴대폰'),
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('수정'))
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
