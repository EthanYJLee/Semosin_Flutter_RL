import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:semosin/services/firebase_delete.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/shoedetail.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  late FireStoreSelect fireStoreSelect;

  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0);

  final List<String> valueList = <String>['담은순', '높은 가격순', '낮은 가격순'];
  late String dropdownValue;
  late String selectedSortValue;
  late bool isDescending;

  final String all = '전체';
  final String nike = '나이키';
  final String adidas = '아디다스';
  final String converse = '컨버스';

  String selectedBrandValue = '전체';

  int dataLength = 0;

  @override
  void initState() {
    super.initState();
    fireStoreSelect = FireStoreSelect();

    dropdownValue = valueList.first;
    selectedSortValue = 'initdate';
    isDescending = true;

    getFavoritesDataLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '관심있는 상품',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          topGroup(),
          favoritesList(),
        ],
      ),
    );
  }

  // Widget Start ----------------------

  Widget topGroup() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            brandButton(all),
            brandButton(nike),
            brandButton(adidas),
            brandButton(converse),
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.24,
              height: MediaQuery.of(context).size.width * 0.088,
              child: DropdownButton<String>(
                alignment: Alignment.centerRight,
                value: dropdownValue,
                icon: const Icon(
                  CupertinoIcons.chevron_down,
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
                underline: Container(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    if (dropdownValue == '담은순') {
                      selectedSortValue = 'initdate';
                      isDescending = true;
                    } else if (dropdownValue == '높은 가격순') {
                      selectedSortValue = 'price';
                      isDescending = true;
                    } else {
                      selectedSortValue = 'price';
                      isDescending = false;
                    }
                  });
                },
                items: valueList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget brandButton(
    brand,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.15,
            MediaQuery.of(context).size.width * 0.088,
          ),
          maximumSize: Size(
            MediaQuery.of(context).size.width * 0.15,
            MediaQuery.of(context).size.width * 0.088,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
              width: 2,
              color: selectedBrandValue == brand ? Colors.black : Colors.grey,
            ),
          ),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          setState(() {
            selectedBrandValue = brand;
            getFavoritesDataLength();
          });
        },
        child: Text(
          brand,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.bold,
            color: selectedBrandValue == brand ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget favoritesList() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 1.62,
      child: FutureBuilder(
        future: fireStoreSelect.selectFavoriteShoes(
          selectedBrandValue,
          selectedSortValue,
          isDescending,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (dataLength > 0) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: MediaQuery.of(context).size.width * 0.7,
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ShoeDetail(
                              modelName: snapshot.data![index].shoeModelName,
                              brandName: snapshot.data![index].shoeBrandName,
                              price: snapshot.data![index].price,
                            );
                          },
                        ),
                      ).then(
                        (value) {
                          setState(() {
                            // ShoeDetail에서 관심등록 해제하고 올 수 있기 때문에 setState
                          });
                        },
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                snapshot.data![index].shoeImageName,
                              ),
                              Positioned(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      unlikeDialog(
                                          snapshot.data![index].shoeModelName);
                                    });
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 3,
                                right: 3,
                                child: Image.asset(
                                  snapshot.data![index].shoeBrandName == '아디다스'
                                      ? './images/converted_adidas.png'
                                      : snapshot.data![index].shoeBrandName ==
                                              '나이키'
                                          ? './images/converted_nike.png'
                                          : snapshot.data![index]
                                                      .shoeBrandName ==
                                                  '컨버스'
                                              ? './images/converted_converse.png'
                                              : './images/googlelogo.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 2),
                            child: Text(
                              snapshot.data![index].shoeBrandName,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.033,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              snapshot.data![index].shoeModelName,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.037,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                            child: Text(
                              '${formatCurrency.format(snapshot.data![index].price)}원',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.033,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        "images/logo_gray.png",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      '관심등록한 상품이 없습니다.',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ));
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CupertinoActivityIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  unlikeDialog(modelName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '좋아요를 취소 하시겠습니까?',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '아니요',
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  FireStoreDelete().deleteFavorite(modelName);
                  unlikeSnackbar();
                });
              },
              child: const Text(
                '네',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  unlikeSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          '삭제 되었습니다.',
        ),
      ),
    );
  }

  // Widget End ------------------------

  // Function Start --------------------

  /// 날짜 : 2023.03.24
  /// 만든이 : 신오수
  /// 설명 : 데이터의 길이 가져오기
  getFavoritesDataLength() async {
    FireStoreSelect firestoreSelect = FireStoreSelect();
    dataLength =
        await firestoreSelect.getFavoritesDataLength(selectedBrandValue);
  }

  // Function End ----------------------
}
