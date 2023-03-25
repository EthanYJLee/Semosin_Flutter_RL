import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kpostal/kpostal.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/services/firestore_update.dart';

enum WhichAddress { mine, another }

class AddressCard extends StatefulWidget {
  /// Desc : 구매하기 View에서 배송지 눌렀을 때 나오는 Popup Card (배송지 수정 기능)
  /// Date : 2023.03.22
  /// Author : youngjin
  const AddressCard({
    super.key,
    required this.name,
    required this.postcode,
    required this.address,
    required this.addressDetail,
  });
  final String name;
  final String postcode;
  final String address;
  final String addressDetail;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  // 기존 배송지 (내 주소)
  late TextEditingController nameController;
  late TextEditingController postcodeController;
  late TextEditingController addressController;
  late TextEditingController addressDetailController;
  // 새로운 배송지 추가
  late TextEditingController newNameController;
  late TextEditingController newPostcodeController;
  late TextEditingController newAddressController;
  late TextEditingController newAddressDetailController;
  late TextEditingController newPhoneController;
  // -
  FirestoreUpdate firestoreUpdate = FirestoreUpdate();
  WhichAddress choice = WhichAddress.mine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    postcodeController = TextEditingController();
    addressController = TextEditingController();
    addressDetailController = TextEditingController();
    newNameController = TextEditingController();
    newPostcodeController = TextEditingController();
    newAddressController = TextEditingController();
    newAddressDetailController = TextEditingController();
    newPhoneController = TextEditingController();
    nameController.text = widget.name;
    postcodeController.text = widget.postcode;
    addressController.text = widget.address;
    addressDetailController.text = widget.addressDetail;
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
                  height: MediaQuery.of(context).size.height / 1.5,
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
                        SizedBox(
                          width: 200,
                          child: SegmentedButton(
                            style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(2),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                            segments: const <ButtonSegment<WhichAddress>>[
                              ButtonSegment<WhichAddress>(
                                  value: WhichAddress.mine,
                                  label: Text(
                                    '내 주소',
                                    style: TextStyle(color: Colors.black),
                                  )),
                              ButtonSegment<WhichAddress>(
                                  value: WhichAddress.another,
                                  label: Text(
                                    '다른 주소',
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                            selected: <WhichAddress>{choice},
                            onSelectionChanged: (Set<WhichAddress> newChoice) {
                              setState(() {
                                // 버튼 누를 때 마다 controller 초기화해주기
                                choice = newChoice.first;
                              });
                            },
                          ),
                        ),
                        choice == WhichAddress.mine
                            ? myAddressWidget()
                            : anotherAddressWidget(),
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
      if (choice == WhichAddress.mine) {
        setState(() {
          postcodeController.text = kpostal.postCode;
          addressController.text = kpostal.address;
        });
      } else {
        setState(() {
          newPostcodeController.text = kpostal.postCode;
          newAddressController.text = kpostal.address;
        });
      }
      // 주소 검색하지 않고 뒤로가기 탭했을 경우
    } else {
      // Nothing Happens
    }
  }

  /// Desc : 기존 배송지 사용 (회원가입 시 입력한 주소)
  /// Date : 2023.03.24
  /// Author : youngjin
  Widget myAddressWidget() {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(helperText: '받는사람'),
          readOnly: true,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextField(
                controller: postcodeController,
                decoration: const InputDecoration(helperText: '우편번호'),
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
          decoration: const InputDecoration(helperText: '상세주소를 입력해주세요'),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('닫기')),
            ElevatedButton(
                onPressed: () async {
                  if (addressDetailController.text.length > 20) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('주소'),
                            content: const Text('주소는 20자 이내로 입력해주십시오'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'))
                            ],
                          );
                        });
                  } else {
                    firestoreUpdate.changeDeliveryInfo(
                        addressController.text.toString(),
                        addressDetailController.text.toString(),
                        postcodeController.text.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('수정')),
          ],
        )
      ],
    );
  }

  /// Desc : 새로운 배송지 추가
  /// Date : 2023.03.24
  /// Author : youngjin
  Widget anotherAddressWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.5,
              child: TextField(
                controller: newNameController,
                decoration: const InputDecoration(helperText: '받는사람'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.2,
              child: TextField(
                controller: newPhoneController,
                decoration: const InputDecoration(helperText: '휴대폰 번호'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextField(
                controller: newPostcodeController,
                decoration: const InputDecoration(helperText: '우편번호 검색'),
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
          controller: newAddressController,
          decoration: const InputDecoration(helperText: '주소'),
          readOnly: true,
        ),
        TextField(
          controller: newAddressDetailController,
          decoration: const InputDecoration(helperText: '상세주소를 입력해주세요'),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              if (newNameController.text.isNotEmpty &
                  newPhoneController.text.isNotEmpty &
                  newPostcodeController.text.isNotEmpty &
                  newAddressController.text.isNotEmpty &
                  newAddressDetailController.text.isNotEmpty) {
                FirestorePay firestorePay = FirestorePay();
                firestorePay.addShippingAddress(
                    newNameController.text.trim(),
                    newPhoneController.text.trim(),
                    newPostcodeController.text.trim(),
                    newAddressController.text.trim(),
                    newAddressDetailController.text.trim());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Column(
                    children: const [
                      SizedBox(
                          height: 15,
                          child: Text(
                            '배송지목록에 추가되었습니다',
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  dismissDirection: DismissDirection.up,
                  duration: const Duration(milliseconds: 500),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Column(
                    children: const [
                      SizedBox(
                          height: 15,
                          child: Text(
                            '모든 정보를 입력해주십시오',
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  dismissDirection: DismissDirection.up,
                  duration: const Duration(milliseconds: 500),
                ));
              }
            },
            child: const Text('추가하기'))
      ],
    );
  }
}
