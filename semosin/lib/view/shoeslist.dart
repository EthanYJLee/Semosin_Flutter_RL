import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:semosin/model/brand_list.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/shoedetail.dart';
import 'package:semosin/view_model/shoe_view_model.dart';

class ShoesList extends StatefulWidget {
  const ShoesList({super.key});

  @override
  State<ShoesList> createState() => _ShoesListState();
}

class _ShoesListState extends State<ShoesList>
    with SingleTickerProviderStateMixin {
  // ------------------------------------------------------------------------------------------
  // Front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 : 호식, 오수
  /// 내용 : 검색 , 브랜드 버튼, 정렬 방법 , list view
  late TextEditingController serach;
  late List<String> images;
  late StreamController<String> streamController;
  late StreamController<List<ShoeViewModel>> streamSheoList;
  late List<ShoeViewModel> myList;

  final ScrollController scrollController = ScrollController();
  List brandList = makeBrandList().imgitems;

  // 가격 문자열 포맷팅 -----------
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0);
  // ---------------------

  // paging 위한 변수 ------
  late int start;
  late int end;
  late int interval;
  late int max;
  // ---------------------

  // button click 시 loading 위한 변수 --------
  late bool btnClicked;
  // ---------------------

  // scroll 하여 데이터 가져오는 중일 시의 상태를 위한 변수 --------
  late bool isLoading;
  // ---------------------

  // brand button 이벤트 받을 변수 -----
  late String brandName;
  // -------------------------------

  // 브랜드명을 브랜드로고로 바꿀 맵 변수 선언 ------
  final Map<String, String> nameLogo = {
    '나이키': 'images/converted_nike.png',
    '아디다스': 'images/converted_adidas.png',
    '컨버스': 'images/converted_converse.png',
    '퓨마': 'images/converted_puma.png',
    '휠라': 'images/converted_fila.png',
  };

  final Map<String, String> buttonLogo = {
    'all': 'images/all.png',
    '나이키': 'images/nike.png',
    '아디다스': 'images/adidas.png',
    '컨버스': 'images/converse2.png',
    '퓨마': 'images/puma.png',
    '휠라': 'images/fila.png',
  };
  // --------------------------------------
  late int currentState = 0;

  @override
  void initState() {
    super.initState();

    serach = TextEditingController();
    // 리스트 목록 바뀌는 거 듣는 변수
    streamSheoList = StreamController<List<ShoeViewModel>>();
    // streamshoelist에 add 할 리스트 변수 초기화
    myList = [];
    // brandName 초기값 설정
    brandName = 'all';
    // btnClicked 값 초기화
    btnClicked = true;
    // isLoading 값 초기화
    isLoading = false;

    // 1. 초기 페이징 값 설정
    interval = 5;
    start = 0;
    end = interval;

    // 2. stream 초기값 지정
    allStreamList();

    // 3. 데이터 길이 받아오기
    getBrandDataLength();

    // 4-1. scroll event 추가
    addScrollEvent();

    // 5-2. streamController(버튼 이벤트) 이벤트 추가
    brandButtonEvent('all');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSheoList.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(10, 0, 0, 0),
      body: Center(
        child: Column(
          children: [
            // app bar 없애서 필요
            const SizedBox(
              height: 10,
            ),
            // 브랜드 버튼 ----------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                // color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                      child: Row(
                        children: const [
                          Text(
                            ' 브랜드 선택',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    branButtons(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // 상품 목록 ----------------------------------------------------------------
            Expanded(
              child: StreamBuilder(
                stream: streamSheoList.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !btnClicked) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        String imagePath =
                            nameLogo[snapshot.data![index].shoeBrandName] ??
                                "images/converted_nike.png";
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShoeDetail(
                                              modelName: snapshot
                                                  .data![index].shoeModelName,
                                              brandName: snapshot
                                                  .data![index].shoeBrandName,
                                            )));
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.network(
                                          snapshot.data![index].shoeImageName),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.538,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 30,
                                                child: Image.asset(
                                                  imagePath,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  snapshot.data![index]
                                                      .shoeModelName,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueGrey[900],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .heart_fill,
                                                        color: Colors.red[400],
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        snapshot.data![index]
                                                            .likeNum
                                                            .toString(),
                                                        style: TextStyle(
                                                          color:
                                                              Colors.red[400],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '${formatCurrency.format(snapshot.data![index].shoePrice)}원',
                                                  // '${formatCurrency.format(int.parse(snapshot.data![index].shoePrice))}원',
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button ------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.play_arrow,
        ),
      ),
    );
  }

  Widget branButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          brandButton('all'),
          brandButton('나이키'),
          brandButton('아디다스'),
          brandButton('컨버스'),
          brandButton('퓨마'),
          brandButton('휠라'),
        ],
      ),
    );
  }

  Widget brandButton(String brand) {
    var imagePath = buttonLogo[brand] ?? "images/nike.png";
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0,
          MediaQuery.of(context).size.width * 0.02, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.22,
        height: MediaQuery.of(context).size.width * 0.14,
        child: ElevatedButton(
          onPressed: () {
            brandButtonEvent(brand);
          },
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 로딩 중일 때 뜨는 바텀 시트 만들기 : scroll 하면서 버튼 동시에 눌렀을 때, 데이터 겹치는 것을 막기 위해서
  showLoadingBottomSheet() {
    final snackBar = SnackBar(
      content: const Text('아직 데이터가 로딩 중입니다.'),
      backgroundColor: Colors.red[400],
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // stream 관련
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 버튼 이벤트 시 발생하는 거
  void brandButtonEvent(String brand) async {
    if (!isLoading) {
      setState(() {
        btnClicked = true;
      });
      brandName = brand;
      myList = [];
      await getBrandDataLength();

      start = 0;
      end = interval > max ? max : interval;

      if (brandName != 'all') {
        brandStreamList();
      } else {
        allStreamList();
      }
    } else {
      showLoadingBottomSheet();
    }
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 브랜드 이름 버튼 클릭 하고 리스트 가져올 때
  void brandStreamList() {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectBrandShoes(brandName, start, end).then((value) {
      if (streamSheoList.isClosed || !mounted) {
        return;
      }
      value.map((e) => myList.add(e)).toList();
      streamSheoList.add(myList);
      setState(() {
        btnClicked = false;
        isLoading = false;
      });
    });
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 전체 버튼 클릭 하고 리스트 가져올 때
  void allStreamList() {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectAllShoes(start, end).then((value) {
      if (streamSheoList.isClosed || !mounted) {
        return;
      }
      value.map((e) => myList.add(e)).toList();
      streamSheoList.add(myList);
      setState(() {
        btnClicked = false;
        isLoading = false;
      });
    });
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // scrollController 관련
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 스크롤 시에 발생하는 이벤트 생성 : 마지막 까지 스크롤 했을 때 데이터 더 가져오기
  addScrollEvent() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          start += interval;
          end += interval;
          if (start < max) {
            if (max - start < interval) {
              end = max;
            }
            setState(() {
              isLoading = true;
            });
            if (brandName != 'all') {
              brandStreamList();
            } else {
              allStreamList();
            }
          }
        }
      }
    });
  }

  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // Backend
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 브랜드 별로의 데이터의 길이 가져오기
  getBrandDataLength() async {
    FireStoreSelect firestoreSelect = FireStoreSelect();
    max = await firestoreSelect.getBrandDataLength(brandName);
  }
}
