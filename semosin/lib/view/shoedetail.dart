import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_update.dart';
import 'package:semosin/services/shoes_info.dart';
import 'package:semosin/view_model/image_path_view_model.dart';
import 'package:semosin/widget/card_dialog.dart';
import 'package:semosin/widget/popup_card.dart';

import '../services/firebase_delete.dart';
import '../services/firebase_favorite.dart';
import '../services/firestore_insert.dart';

class ShoeDetail extends StatefulWidget {
  const ShoeDetail(
      {super.key, required this.modelName, required this.brandName});

  // click 시 모델 이름 받아오기
  final String modelName;
  final String brandName;

  // image path 받아오기

  @override
  State<ShoeDetail> createState() => _ShoeDetailState();
}

class _ShoeDetailState extends State<ShoeDetail> {
  // 페이지뷰를 위해 Storage에서 받아온 Image Path 담아주기
  late List<String> images = [];
  // 이미지 넘기는 index
  int selectedImageIndex = 0;
  // Page Controller
  late PageController pageController =
      PageController(initialPage: selectedImageIndex);
  // 선택된 사이즈
  String? selectedSize;
  List<int> sizeList = [];
  // 선택한 사이즈의 남은 수량
  String? availableQuantity;
  // 선택한 상품 수량
  int productCount = 1;
  // 선택된 신발색상
  Color selectedColor = Colors.black;

  // 북마크 아이콘(관심있는 상품)
  bool bookmark = false;

  // 로딩중
  late bool isLoading;
  // 선택한 신발 정보
  ShoesInfo shoesInfo = ShoesInfo();
  // 이미지 경로 뷰모델
  late ImagePathViewModel imagePathViewModel;

  // ------------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : shoe detail 정보 보여주기
  // late bool isLoading;

  @override
  void initState() {
    super.initState();
    // 빈 이미지 ViewModel 생성
    imagePathViewModel = ImagePathViewModel(imagePath: []);
    isLoading = true;
    checkFavorite();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? loadingTrueWidget() : getDataWidget();
    return getDataWidget();
  }
  // ------------------------------------------------ WIDGET ------------------------------------------------

  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : 로딩 중일 때 뜰 위젯
  loadingTrueWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 : 이성연, 이영진
  /// 내용 : 데이터 받아 왓을 때 뜰 위젯
  getDataWidget() {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20, // safearea를 사용하면 시간 및 배터리가 보이지 않음
              ),

              // 제품명 타이틀 -----------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.modelName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (MediaQuery.of(context).size.width / 20),
                      ),
                    ),
                  ],
                ),
              ),

              // 이미지 pageview -------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    width: 500,
                    height: 600,
                    child: FutureBuilder(
                      future: shoesInfo.selectModelNameData(widget.modelName),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // ---------- Firebase Storage의 Image URL 불러오기 ----------
                          getImageURL(snapshot.data!.images as List<String>);
                          return Column(
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                child: imagePathViewModel.imagePath.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(70),
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )
                                    // 상품 Image Page View ---------------------------
                                    : PageView.builder(
                                        controller: pageController,
                                        onPageChanged: (value) {
                                          setState(() {
                                            selectedImageIndex = value;
                                            print(selectedImageIndex);
                                          });
                                        },
                                        itemCount:
                                            imagePathViewModel.imagePath.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Card(
                                                      child: Image.network(
                                                          imagePathViewModel
                                                                  .imagePath[
                                                              index]),
                                                    ),
                                                    Positioned(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              bookmark =
                                                                  !bookmark;
                                                            });
                                                            // print(bookmark);
                                                            FirestoreUpdate
                                                                firestoreUpdate =
                                                                FirestoreUpdate();
                                                            if (bookmark) {
                                                              await FireStoreInsert().insertFavorite(
                                                                  widget
                                                                      .modelName,
                                                                  widget
                                                                      .brandName,
                                                                  imagePathViewModel
                                                                      .imagePath[0]);
                                                              // 슈즈 라이크 카운트 +1 기능 추가
                                                              firestoreUpdate
                                                                  .incrementLikes(
                                                                      widget
                                                                          .modelName);
                                                            } else {
                                                              await FireStoreDelete()
                                                                  .deleteFavorite(
                                                                      widget
                                                                          .modelName);
                                                              // 슈즈 라이크 카운트 -1 기능 추가
                                                              firestoreUpdate
                                                                  .decrementLikes(
                                                                      widget
                                                                          .modelName);
                                                            }
                                                            FireStoreFavorite()
                                                                .isFavorite(widget
                                                                    .modelName);
                                                          },
                                                          icon: Icon(
                                                            bookmark
                                                                ? Icons
                                                                    .bookmark_outlined
                                                                : Icons
                                                                    .bookmark_outline,
                                                            size: 44,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: images.map((image) {
                                    int index = images.indexOf(image);

                                    return GestureDetector(
                                      onTap: () {
                                        print(index);
                                        setState(() {
                                          selectedImageIndex = index;
                                          if (pageController.hasClients) {
                                            pageController.animateToPage(
                                              selectedImageIndex,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              index == selectedImageIndex
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade300,
                                          radius: 5,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                              // 상품명 및 가격 -----------------------------------------------------
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!.brand,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            '${snapshot.data!.price}원',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const VerticalDivider(
                                      width: 100,
                                      thickness: 2,
                                      indent: 0,
                                      endIndent: 0,
                                    ),

                                    /// Desc : 상품정보제공 고시 Dialog (제조사, 제조국, 소재, 굽높이)
                                    /// Date : 2023.03.20
                                    /// Author : youngjin
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            CardDialog(builder: (context) {
                                          return PopupCard(
                                            maker: snapshot.data!.maker,
                                            country: snapshot.data!.country,
                                            color: snapshot.data!.colors![0],
                                            material: snapshot.data!.material,
                                            height: snapshot.data!.height,
                                          );
                                        }));
                                      },
                                      child: const Text(
                                        '상품정보 보기',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                              // 사이즈 선택---------------------------------------------------
                              Container(
                                height: 50,
                                width: 350,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IntrinsicHeight(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Row(
                                          children: [
                                            // const SizedBox(
                                            //   width: 10,
                                            // ),
                                            selectedSize == null
                                                ? const Text("")
                                                : const Text("Size:",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            TextButton(
                                              onPressed: () {
                                                showSizeBottomSheet(context,
                                                    snapshot.data!.sizes!);
                                              },
                                              child: Text(
                                                  selectedSize ?? "사이즈 선택",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              width: 80,
                                              child: availableQuantity == null
                                                  ? const Text("")
                                                  : Text(
                                                      '수량:  ${availableQuantity.toString()}',
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                            const VerticalDivider(
                                              width: 40,
                                              thickness: 2,
                                              indent: 0,
                                              endIndent: 0,
                                            ),
                                            countProduct(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(
                                thickness: 2,
                              ),
                              // 제품설명 ---------------------------------------------------------
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: SizedBox(
                                  width: 350,
                                  height: 140,
                                  child: SingleChildScrollView(
                                    // 글자수가 sized 박스를 넘어갈수도 있기 때문에 스크롤뷰로 해놈
                                    child: Column(
                                      children: [
                                        Text(
                                          '소재별 관리방법: ${snapshot.data!.method}',
                                          softWrap: true,
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 70, 70, 70),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 신발 색상선택 ---------------------------------------------------------
                              // 색상 형식이 통일이 안 되어있어서 사용불가
                              // SizedBox(
                              //   height:
                              //       52, // 이미지 선택시 커지는 효과 때문에 밑에 버튼의 위치가 움직여서 사이즈를 고정시켜놈
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.all(4.0),
                              //         child: Row(
                              //           children: [
                              //             const Text(
                              //               "색상 : ",
                              //               style: TextStyle(fontSize: 20),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(4.0),
                              //               child:
                              //                   buildColorButton(Colors.black),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(4.0),
                              //               child: Container(
                              //                 decoration: BoxDecoration(
                              //                   borderRadius:
                              //                       BorderRadius.circular(50),
                              //                   border: Border.all(
                              //                       color: Colors.black,
                              //                       width: 1),
                              //                 ),
                              //                 child: buildColorButton(
                              //                     Colors.white),
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(4.0),
                              //               child: buildColorButton(Colors.red),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                              // 장바구니, 구매하기 버튼 ------------------------------------------------------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedSize == null
                                            ? const Color.fromARGB(157, 0, 0, 0)
                                            : Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (availableQuantity != null) {
                                          if (productCount >
                                              int.parse(availableQuantity!)) {
                                            checkQuantities('잔여수량을 확인해주세요');
                                          }
                                        }
                                        if (selectedSize != null) {
                                          addToCart(
                                              widget.modelName,
                                              productCount,
                                              int.parse(snapshot.data!.price),
                                              int.parse(selectedSize!));
                                        } else {
                                          checkQuantities('사이즈를 선택해주세요');
                                        }
                                      },
                                      child: const Text("장바구니"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 180,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedSize == null
                                            ? const Color.fromARGB(157, 0, 0, 0)
                                            : Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (availableQuantity != null) {
                                          if (productCount >
                                              int.parse(availableQuantity!)) {
                                            checkQuantities('잔여수량을 확인해주세요');
                                          }
                                        }
                                        if (selectedSize != null) {
                                          checkOut(
                                              widget.modelName,
                                              productCount,
                                              int.parse(snapshot.data!.price),
                                              int.parse(selectedSize!));
                                        } else {
                                          checkQuantities('사이즈를 선택해주세요');
                                        }
                                      },
                                      child: const Text("구매하기"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
              ),

              // const SizedBox(
              //   height: 20,
              // ),

              // 장바구니 / 구매하기 버튼 ---------------------------------------------
            ],
          ),
        ),
      ),
    );
  }

  /// Desc : 신발색상 선택 위젯
  /// Author : 이성연
  /// Note : 색상 코드 통일 해결할 때까지 사용 보류
  // Widget buildColorButton(Color color) {
  //   const double selectedSize = 30;
  //   const double unselectedSize = 20;
  //   String resultColor; // 선택한 색상을 문자로 출력하기 위해
  //   resultColor = "black"; // 기본값
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedColor = color;
  //         if (selectedColor == Colors.white) {
  //           resultColor = "white";
  //         } else if (selectedColor == Colors.black) {
  //           resultColor = "black";
  //         } else {
  //           resultColor = "red";
  //         }
  //         print(resultColor);
  //       });
  //     },
  //     child: Container(
  //       width: selectedColor == color ? selectedSize : unselectedSize,
  //       height: selectedColor == color ? selectedSize : unselectedSize,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: color,
  //       ),
  //       // child: selectedColor == color
  //       //     ? const Icon(Icons.check, size: 20, color: Colors.grey)
  //       //     : null,
  //     ),
  //   );
  // }

  /// Desc : 신발 수량 +/- (FloatingActionButton)
  /// Date : 2023.03.20
  /// Author : youngjin
  Widget countProduct() {
    return Container(
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 0,
                heroTag: 'minus_one',
                onPressed: () {
                  setState(() {
                    if (productCount > 1) {
                      productCount--;
                    }
                  });
                },
                backgroundColor: const Color.fromARGB(255, 124, 124, 124),
                foregroundColor: Colors.black,
                child: const Icon(
                  Icons.remove,
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Text(
              productCount.toString(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 30,
            width: 30,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 0,
                heroTag: 'plus_one',
                onPressed: () {
                  setState(() {
                    productCount++;
                  });
                },
                backgroundColor: const Color.fromARGB(255, 124, 124, 124),
                foregroundColor: Colors.black,
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------------------------------------

  // ------------------------------------------------ FUNCTIONS ------------------------------------------------

  /// Desc : 선택한 수량이 잔여 수량보다 많을 경우 Alert Dialog
  /// Date : 2023.03.22
  /// Author : youngjin
  checkQuantities(String comment) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              '상품 확인',
            ),
            content: Text(
              comment,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  /// Desc : 사이즈 선택 Modal Bottom Sheet
  /// Date : 2023.03.20
  /// Author : 이성연, 이영진

  void showSizeBottomSheet(BuildContext context, Map<String, int> sizes) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Select Size',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(
                  sizes.keys.length, // 버튼갯수
                  (int index) {
                    /// Desc : Map<사이즈,잔여수량>을 사이즈별로 재정렬
                    /// Date : 2023.03.20
                    /// Author : youngjin
                    Map<String, int> sortedMap = Map.fromEntries(
                        sizes.entries.toList()
                          ..sort((e1, e2) => e1.key.compareTo(e2.key)));

                    final size = sortedMap.keys.toList()[index].toString();
                    final isSelected = size == selectedSize;

                    final quantity =
                        sortedMap.values.toList()[index].toString();

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSize = size.toString();
                          availableQuantity = quantity.toString();
                          print(availableQuantity);
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        backgroundColor:
                            isSelected ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text('${size}mm',
                              style: const TextStyle(fontSize: 18)),
                          Text('남은 수량 : ${sortedMap.values.toList()[index]}')
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Desc : 장바구니 다이어로그창
  /// Date : 2023.03.20
  /// Author : 이성연
  void addToCart(String model, int count, int price, int size) {
    if (selectedSize == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("사이즈를 선택해주세요"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "확인",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("장바구니"),
          content: Container(
              height: 120,
              width: 150,
              child: Column(
                children: [
                  const Text(
                    "해당제품을 장바구니에 \n담으시겠습니까?",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(model),
                  Text("수량:$count"),
                  Text("총액:${count * price}원"),
                ],
              )),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "취소",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "담기",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // ------------------------------------------------
                // FireStoreInsert fireStoreInsert = FireStoreInsert();
                // fireStoreInsert.insertIntoCart(
                //     model, imagePathViewModel.imagePath[0], size, price, count);
                // Navigator.of(context).pop();
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: const Text('상품이 장바구니에 담겼습니다'),
                //         actions: [
                //           TextButton(
                //               onPressed: () {}, child: const Text('홈으로')),
                //           TextButton(
                //               onPressed: () {}, child: const Text('장바구니로 이동'))
                //         ],
                //       );
                //     });
              },
            ),
          ],
        );
      },
    );
  }

  /// Desc : 구매하기 버튼 다이어로그창
  /// Date : 2023.03.20
  /// Author : 이성연
  void checkOut(String model, int count, int price, int size) {
    if (selectedSize == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("사이즈를 선택해주세요"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "확인",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("구매"),
          content: Container(
            height: 120,
            width: 150,
            child: Column(
              children: [
                const Text(
                  "해당제품을 구매하러 가시겠습니까?",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(model),
                Text("수량:$count"),
                Text("총액:${count * price}원"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "취소",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "구매",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // ------------------------------------------------
              },
            ),
          ],
        );
      },
    );
  }

  /// Desc : 신발 이미지 가져오기
  /// Date : 2023.03.19
  /// Author : youngjin
  Future<void> getImageURL(List<String> path) async {
    List<String> pathList = [];
    for (int i = 0; i < path.length; i++) {
      var downloadURL = await FirebaseStorage.instance
          .ref('신발 이미지')
          .child(path[i].substring(8))
          .getDownloadURL();
      // setState(() {
      pathList.add(downloadURL.toString());
      // });
    }

    if (mounted) {
      setState(() {
        images = pathList;
        imagePathViewModel = ImagePathViewModel(imagePath: pathList);
      });
    }
  }

  Future<void> checkFavorite() async {
    bool result = await FireStoreFavorite().isFavorite(widget.modelName);
    setState(() {
      bookmark = result;
    });
  }
}
