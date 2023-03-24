import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kpostal/kpostal.dart';
import 'package:semosin/services/firestore_update.dart';

class AddressCard extends StatefulWidget {
  /// Desc : 구매하기 View에서 배송지 눌렀을 때 나오는 Popup Card (배송지 수정 기능)
  /// Date : 2023.03.22
  /// Author : youngjin
  const AddressCard(
      {super.key,
      required this.postcode,
      required this.address,
      required this.addressDetail,
      required this.phone});
  final String postcode;
  final String address;
  final String addressDetail;
  final String phone;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  late TextEditingController postcodeController;
  late TextEditingController addressController;
  late TextEditingController addressDetailController;
  late TextEditingController phoneController;
  FirestoreUpdate firestoreUpdate = FirestoreUpdate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postcodeController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    addressDetailController = TextEditingController();
    postcodeController.text = widget.postcode;
    addressController.text = widget.address;
    addressDetailController.text = widget.addressDetail;
    phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
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
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            '배송지',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.7,
                              child: TextField(
                                controller: postcodeController,
                                decoration:
                                    const InputDecoration(helperText: '우편번호'),
                                readOnly: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                onPressed: () async {
                                  searchAddress();
                                },
                                icon: const Icon(Icons.search),
                              ),
                            )
                          ],
                        ),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(helperText: '주소'),
                          readOnly: true,
                        ),
                        TextField(
                          controller: addressDetailController,
                          decoration:
                              const InputDecoration(helperText: '상세주소를 입력해주세요'),
                        ),
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                              helperText: '휴대폰 번호를 입력해주세요'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              firestoreUpdate.changeDeliveryInfo(
                                  addressController.text.toString(),
                                  addressDetailController.text.toString(),
                                  postcodeController.text.toString(),
                                  phoneController.text.toString());
                              Navigator.of(context).pop();
                            },
                            child: const Text('수정'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// Desc : 주소찾기 (Kpostal)
  /// Date : 2023.03.24
  /// Author : youngjin
  searchAddress() async {
    Kpostal kpostal;
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KpostalView(
            callback: (Kpostal result) {
              print(result.address);
            },
          ),
        ));
    // 주소를 검색했을 경우
    if (result != null) {
      kpostal = result;
      setState(() {
        postcodeController.text = kpostal.postCode;
        addressController.text = kpostal.address;
      });
      // 주소 검색하지 않고 뒤로가기 탭했을 경우
    } else {
      // Nothing Happens
    }
  }
}
