import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpostal/kpostal.dart';
import 'package:semosin/services/firestore_pay.dart';
import 'package:semosin/services/firestore_update.dart';
import 'package:semosin/widget/phone_formatter.dart';

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
  // 전화번호 TextInputFormatter
  List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    NumberFormatter(),
    LengthLimitingTextInputFormatter(13)
  ];
  // TextField FocusNode
  late FocusNode addressDetailFocusNode;
  late FocusNode newNameFocusNode;
  late FocusNode newPhoneFocusNode;
  late FocusNode newAddressDetailFocusNode;
  // TextField Check
  late String addressDetailCheck;
  late String newNameCheck;
  late String newPhoneCheck;
  late String newAddressDetailCheck;

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

    // 휴대폰 번호 초기 세팅
    newPhoneController.text = '010';
    // Focus Node
    addressDetailFocusNode = FocusNode();
    newNameFocusNode = FocusNode();
    newPhoneFocusNode = FocusNode();
    newAddressDetailFocusNode = FocusNode();

    // text check
    addressDetailCheck = '';
    newNameCheck = '';
    newPhoneCheck = '';
    newAddressDetailCheck = '';

    focusListener();
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

  // --------------------------- WIDGETS ---------------------------

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
                child: textFormField(newNameController, false, newNameFocusNode,
                    TextInputType.text, '받는 사람', null, null, false)),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: textFormField(
                    newPhoneController,
                    false,
                    newPhoneFocusNode,
                    TextInputType.number,
                    '연락처',
                    phoneFormatter,
                    null,
                    false)),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: textFormField(newPostcodeController, true, null,
                  TextInputType.number, '우편번호 검색', null, null, false),
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
        textFormField(newAddressController, true, null, TextInputType.number,
            '주소', null, null, false),
        textFormField(
            newAddressDetailController,
            false,
            newAddressDetailFocusNode,
            TextInputType.text,
            '상세주소',
            null,
            null,
            false),
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

  // --------------------------- FUNCTIONS ---------------------------

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

  /// Desc : 배송지 추가 시 사용되는 TF
  /// Date : 2023.03.27
  /// Author : youngjin
  textFormField(controller, readOnly, focusNode, keyboardType, helperText,
      inputFormatters, onChanged, isObscure) {
    return SizedBox(
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(helperText: helperText),
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isObscure,
      ),
    );
  }

  // 입력한 휴대폰 번호 형식에 부합하는지 체크
  bool isValidPhoneNumberFormat(phoneInput) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(phoneInput);
  }

  /// 날짜 : 2023.03.14
  /// 작성자 : 신오수
  /// 만든이 : 신오수
  /// 내용 : textField에서 포커스가 풀릴때 정규식, 빈값확인, 중복확인 진행
  focusListener() {
    newNameFocusNode.addListener(() {
      setState(() {
        if (!newNameFocusNode.hasFocus) {
          if (newNameController.text.trim().isEmpty) {
            newNameCheck = '이름을 입력하세요.';
          } else {
            newNameCheck = '';
          }
        } else {
          newNameCheck = '';
        }
      });
    });

    newPhoneFocusNode.addListener(() {
      setState(() {
        if (!newPhoneFocusNode.hasFocus) {
          if (newPhoneController.text.trim() == '010') {
            // 사용자가 010에서 입력을 안했을 경우
            newPhoneCheck = '전화번호를 입력하세요.';
            // signUpButtonEnabled[2] = false;
          } else if (newPhoneController.text.trim().length == 13) {
            // -를 포함한 전화번호 길이가 13일 경우
            if (isValidPhoneNumberFormat(newPhoneController.text.trim())) {
              // 사용자가 정규식을 잘 지켰을 경우
              newPhoneCheck = '';
            } else {
              // 사용자가 정규식을 지키지 않았을 경우
              newPhoneCheck = '유효한 전화번호를 입력해주세요.';
            }
          } else {
            // -를 포함한 전화번호 길이가 13보다 짧을 경우
            newPhoneCheck = '올바른 전화번호를 입력해주세요.';
          }
        } else {
          // phoneTextField에 focus가 있을 경우
          newPhoneCheck = '';
        }
      });
    });
    newAddressDetailFocusNode.addListener(() {
      setState(() {
        if (!newAddressDetailFocusNode.hasFocus) {
          if (newAddressController.text.trim().isEmpty) {
            newAddressDetailCheck = '상세주소를 입력하세요.';
            // signUpButtonEnabled[2] = false;
          } else {
            newAddressDetailCheck = '';
          }
        } else {
          newAddressDetailCheck = '';
        }
      });
    });
  }
}
