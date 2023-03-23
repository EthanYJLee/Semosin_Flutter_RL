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

  late List brandButtonGroup;

  final List<String> valueList = <String>['담은순', '높은 가격순', '낮은 가격순'];
  late String dropdownValue;
  late String selectedSortValue;
  late bool isDescending;

  final String all = '전체';
  final String nike = '나이키';
  final String adidas = '아디다스';
  final String converse = '컨버스';

  String selectedBrandValue = '전체';

  @override
  void initState() {
    super.initState();
    fireStoreSelect = FireStoreSelect();

    brandButtonGroup = [true, false, false, false];

    dropdownValue = valueList.first;
    selectedSortValue = 'initdate';
    isDescending = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              '관심있는 상품',
              style: TextStyle(
                fontSize: 20,
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
            Padding(
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
                      color: brandButtonGroup[0] == true
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    brandButtonGroup = [true, false, false, false];
                    selectedBrandValue = all;
                  });
                },
                child: Text(
                  all,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: brandButtonGroup[0] == true
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
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
                      color: brandButtonGroup[1] == true
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    brandButtonGroup = [false, true, false, false];
                    selectedBrandValue = nike;
                  });
                },
                child: Text(
                  nike,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: brandButtonGroup[1] == true
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
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
                      color: brandButtonGroup[2] == true
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    brandButtonGroup = [false, false, true, false];
                    selectedBrandValue = adidas;
                  });
                },
                child: Text(
                  adidas,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: brandButtonGroup[2] == true
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
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
                      color: brandButtonGroup[3] == true
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    brandButtonGroup = [false, false, false, true];
                    selectedBrandValue = converse;
                  });
                },
                child: Text(
                  converse,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: brandButtonGroup[3] == true
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
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
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 278,
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
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
                                        : snapshot.data![index].shoeBrandName ==
                                                '컨버스'
                                            ? './images/converted_converse.png'
                                            : './images/googlelogo.png',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 2),
                          child: Text(
                            snapshot.data![index].shoeBrandName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            snapshot.data![index].shoeModelName,
                            style: const TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                          child: Text(
                            '${formatCurrency.format(snapshot.data![index].price)}원',
                            style: const TextStyle(
                              fontSize: 13,
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
          title: const Text(
            '좋아요를 취소 하시겠습니까?',
            style: TextStyle(
              fontSize: 18,
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

  // Function End ----------------------
}
