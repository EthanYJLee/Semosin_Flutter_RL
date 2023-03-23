import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:semosin/services/firestore_select.dart';
import 'package:semosin/view/shoedetail.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:semosin/widget/info_dialog.dart';
import 'package:semosin/widget/sort_dialog.dart';

class ShoesList extends StatefulWidget {
  const ShoesList({super.key});

  @override
  State<ShoesList> createState() => _ShoesListState();
}

class _ShoesListState extends State<ShoesList> with TickerProviderStateMixin {
  // ------------------------------------------------------------------------------------------
  // Front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 : 호식, 오수
  /// 내용 : 검색 , 브랜드 버튼, 정렬 방법 , list view
  late StreamController<String> streamController;
  late StreamController<List<ShoeViewModel>> streamSheoList;
  late List<ShoeViewModel> myList;

  final ScrollController scrollController = ScrollController();

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

  // brand button 이벤트 받을 변수 -----
  late String brandName;
  // -------------------------------

  // search 검색 바 관련 변수 ----------
  late double searchWidth;
  late double searchHeight;
  late double searchPadding;
  late double searchOpacity;
  late bool searchClickState;
  late bool searchIsDoingAnimation;
  late Color? searchColor;
  late TextEditingController searchEditingController;
  // -------------------------------

  // 정렬 관련 변수 --------------------
  late List<Color?> sortColors;
  late List<String> sortButtonTexts;
  late List<bool> sortSelectList;
  late String sortValues;
  late String sortText;
  late StreamController<String> streamSortValues;
  Color selectColor = const Color.fromARGB(150, 199, 198, 198);
  Color unselectColor = Colors.white;

  // 버튼, 텍스트, 정렬 이벤트 발생시 true 값 추가됨
  late int key;
  late int keyMax;
  late Map<int, List<ShoeViewModel>> tempShoeViewModelList;

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
    // 변수 초기화 ----------------------------------------------
    // 리스트 목록 바뀌는 거 듣는 변수
    streamSheoList = StreamController<List<ShoeViewModel>>();
    // streamshoelist에 add 할 리스트 변수 초기화
    myList = [];
    // brandName 초기값 설정
    brandName = 'all';
    // 검색 관련 값들 초기화
    searchWidth = 0;
    searchHeight = 10;
    searchClickState = false;
    searchColor = null;
    searchPadding = 0;
    searchOpacity = 0;
    searchIsDoingAnimation = false;
    searchEditingController = TextEditingController();
    // 정렬 관련 값들 초기화
    sortColors = [unselectColor, unselectColor, selectColor];
    sortButtonTexts = ['모델명', '가격별', '브랜드명'];
    sortSelectList = [false, false, true];
    sortValues = 'brand';
    sortText = '모델명';
    streamSortValues = StreamController();
    streamSortValues.stream.listen((event) {
      sortValueChanged(event);
    });

    // 이벤트 관련 값들 초기화
    key = 0;
    keyMax = 0;
    tempShoeViewModelList = {};
    // ------------------------------------------------------

    // 1. 초기 페이징 값 설정
    interval = 5;
    start = 0;
    end = interval;

    // 2. stream 초기값 지정
    allStreamList(null);

    // 3. 데이터 길이 받아오기
    getBrandDataLength();

    // 4-1. scroll event 추가
    addScrollEvent();
  }

  @override
  void dispose() {
    super.dispose();
    streamSheoList.close();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      searchWidth = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(10, 0, 0, 0),
      body: Center(
        child: Column(
          children: [
            // app bar 없애서 필요
            const SizedBox(
              height: 10,
            ),
            // 브랜드 버튼 ---------------------------------------------------------------
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
            // 검색 바 -----------------------------------------------------------------
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.elasticInOut,
              width: searchWidth,
              height: searchHeight,
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              constraints: BoxConstraints(
                minWidth: 0,
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: 0,
                maxHeight: 60,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: searchColor),
              child: searchTfWidget(),
            ),
            const SizedBox(
              height: 10,
            ),
            // 상품 목록 ----------------------------------------------------------------
            Expanded(
              child: StreamBuilder(
                stream: streamSheoList.stream,
                builder: (context, snapshot) {
                  // 데이터 로딩 되었을 때
                  if (snapshot.hasData && key == 0) {
                    // 데이터 로딩 되었는데 있을 때
                    if (snapshot.data!.isNotEmpty) {
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
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Image.network(snapshot
                                            .data![index].shoeImageName),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.538,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[900],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                          color:
                                                              Colors.red[400],
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
                      // 데이터 로딩 되었는데 없을 때
                    } else {
                      if (searchEditingController.text == "") {
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
                                '해당 브랜드 상품이 준비 중입니다.',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ],
                        ));
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
                                '해당 검색 데이터가 없습니다.',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ],
                        ));
                      }
                    }
                    // 데이터 로딩 중일 때
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
      /// 날짜 : 2023.03.22
      /// 만든이 : 권순형
      /// 설명 : 정렬 및 검색 기능을 floating action button 에 넣어서 사용하기 위해서
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        icon: Icons.add,
        activeIcon: Icons.close,
        direction: SpeedDialDirection.up,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        spacing: 3,
        useRotationAnimation: true,
        animationCurve: Curves.easeInOutQuart,
        children: [
          // 검색
          SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () => showSearchView(),
          ),
          // 정렬 기준
          SpeedDialChild(
            child: const Icon(Icons.sort),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () => showSortDialog(),
          ),
          // 기타 문의사항 관련 정보 보여주는 곳
          SpeedDialChild(
            child: const Icon(Icons.help_outline),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () => showInfoDialog(),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------
  // Floating Action Button 관련 -------------------------------------------------------------------------
  // 검색 버튼 , 검색 창 관련 ----------------------------------------------------------------------
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : search view가 나올 때 어떤 식으로 애니메이션을 줄지 결정하는 부분
  showSearchView() async {
    if (searchIsDoingAnimation) {
      return;
    }

    searchIsDoingAnimation = true;

    var state = searchClickState;
    searchClickState = !searchClickState;

    if (state) {
      setState(() {
        searchOpacity = 0;
        searchEditingController.text = "";
      });

      await Future.delayed(const Duration(milliseconds: 2500));

      setState(() {
        searchWidth = 0;
        searchHeight = 10;
        searchColor = null;
      });

      await Future.delayed(const Duration(milliseconds: 3500));
    } else {
      setState(() {
        searchWidth = MediaQuery.of(context).size.width;
        searchHeight = 60;
        searchColor = Colors.white;
      });

      await Future.delayed(const Duration(milliseconds: 3500));

      setState(() {
        searchOpacity = 1;
      });

      await Future.delayed(const Duration(milliseconds: 2500));
    }
    searchIsDoingAnimation = false;
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : search view
  Widget searchTfWidget() {
    return AnimatedOpacity(
      opacity: searchOpacity,
      duration: const Duration(seconds: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: searchEditingController,
              ),
            ),
          ),
          IconButton(
            onPressed: () => searchTextShoesList(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------------------------
  // 정렬 버튼 관련  -----------------------------------------------------------------------------
  /// 날짜 : 2023.03.22
  /// 만든이 : 권순형
  /// 설명 : 무엇으로 정렬 할 건지 정할 수 있는 dialog
  showSortDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ShowSortDialog(
          sortColors: sortColors,
          sortButtonTexts: sortButtonTexts,
          sortSelectList: sortSelectList,
          sortValues: sortValues,
          streamController: streamSortValues,
        );
      },
    );
  }

  // ------------------------------------------------------------------------------------------
  // 정보 버튼 관련  -----------------------------------------------------------------------------
  showInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ShowInfoDialog();
      },
    );
  }
  // ------------------------------------------------------------------------------------------
  // -----------------------------------------------------------------------------------------------------
  // -----------------------------------------------------------------------------------------------------

  // 브랜드 버튼 관련 -----------------------------------------------------------------------------
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 버튼 전체 나오는 위젯
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

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 버튼 하나하나의 위젯
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
  // event 관련
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 버튼 이벤트 시 발생하는 거
  void brandButtonEvent(String brand) async {
    setState(() {
      key++;
    });
    keyMax = key;

    brandName = brand;
    await getBrandDataLength();

    start = 0;
    end = interval > max ? max : interval;

    if (brandName != 'all') {
      specificShoesList(key);
    } else {
      allStreamList(key);
    }
  }

  sortValueChanged(String event) async {
    setState(() {
      key++;
    });
    keyMax = key;

    sortText = event;
    if (event == '모델명') {
      setState(() {
        sortValues = 'model';
      });
    } else if (event == '가격별') {
      setState(() {
        sortValues = 'price';
      });
    } else {
      setState(() {
        sortValues = 'brand';
      });
    }

    await getBrandDataLength();

    start = 0;
    end = interval > max ? max : interval;

    if (brandName != 'all') {
      specificShoesList(key);
    } else {
      allStreamList(key);
    }
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : search 버튼 눌렀을 때
  searchTextShoesList() async {
    setState(() {
      key++;
    });
    keyMax = key;

    await getBrandDataLength();

    start = 0;
    end = interval > max ? max : interval;

    if (brandName != 'all') {
      specificShoesList(key);
    } else {
      allStreamList(key);
    }
  }

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
            if (brandName != 'all') {
              specificShoesList(null);
            } else {
              allStreamList(null);
            }
          }
        }
      }
    });
  }
  // ------------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------------
  // stream 관련
  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 브랜드 이름 버튼 클릭 하고 리스트 가져올 때
  void specificShoesList(int? streamKey) {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect
        .selectSpecificBrandShoes(
            brandName, searchEditingController.text, sortValues, start, end)
        .then((value) {
      // tabbar 이동 시 stream에서 나온 변수 저장 안하기 위해서
      if (streamSheoList.isClosed || !mounted) {
        return;
      }
      if (streamKey == null) {
        value.map((e) => myList.add(e)).toList();
        streamSheoList.add(myList);
      } else {
        if (streamKey == keyMax) {
          setState(() {
            key = 0;
          });
          streamSheoList.add(value);
          myList = value;
        }
      }
    });
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : 전체 버튼 클릭 하고 리스트 가져올 때
  void allStreamList(int? streamKey) {
    FireStoreSelect fireStoreSelect = FireStoreSelect();
    fireStoreSelect
        .selectSpecificAllShoes(
            searchEditingController.text, sortValues, start, end)
        .then((value) {
      if (streamSheoList.isClosed || !mounted) {
        return;
      }
      if (streamKey == null) {
        value.map((e) => myList.add(e)).toList();
        streamSheoList.add(myList);
      } else {
        if (streamKey == keyMax) {
          setState(() {
            key = 0;
          });
          streamSheoList.add(value);
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
    max = await firestoreSelect.getBrandDataLength(
        brandName, searchEditingController.text);
  }
  // ------------------------------------------------------------------------------------------
}
