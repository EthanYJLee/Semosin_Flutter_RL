import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:semosin/model/selected_shoe.dart';
import 'package:semosin/services/shoes_info.dart';
import 'package:semosin/view_model/image_path_view_model.dart';
import 'package:semosin/widget/shoe.dart';

class ShoeDetail extends StatefulWidget {
  const ShoeDetail({super.key, required this.modelName});

  // click 시 모델 이름 받아오기
  final String modelName;

  // image path 받아오기

  @override
  State<ShoeDetail> createState() => _ShoeDetailState();
}

class _ShoeDetailState extends State<ShoeDetail> {
  // 임의 이미지 리스트
  final List<String> images = [
    'images/converse.png',
    'images/googlelogo.png',
    'images/vanGogh.jpeg',
    'images/vanGogh2.jpeg'
  ];

  int selectedImageIndex = 0; // 이미지 넘기는 index

  String? selectedSize; // 선택된 사이즈

  Color selectedColor = Colors.black; // 선택된 신발색상

  bool bookmark = false; // 북마크 아이콘(관심있는 상품)
  // 로딩중
  late bool isLoading;
  // 선택한 신발 정보
  ShoesInfo shoesInfo = ShoesInfo();
  // 이미지 경로 뷰모델
  late ImagePathViewModel imagePathViewModel;
  late SelectedShoe selectedShoe;

  // ------------------------------------------------------------------------------------------
  // front
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : shoe detail 정보 보여주기
  // late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 빈 이미지 ViewModel 생성
    imagePathViewModel = ImagePathViewModel(imagePath: []);
    isLoading = true;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? loadingTrueWidget() : getDataWidget();
    return getDataWidget();
  }

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
  /// 만든이 :
  /// 내용 : 데이터 받아 왓을 때 뜰 위젯
  getDataWidget() {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60, // safearea를 사용하면 시간 및 배터리가 보이지 않음
              ),

              // 제품명 타이틀 -----------------------------------------------------
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  widget.modelName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),

              // 이미지 pageview -------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    width: 380,
                    height: 280,
                    child: FutureBuilder(
                      future: shoesInfo.selectModelNameData(widget.modelName),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          getImageURL(snapshot.data!.images as List<String>);
                          return Column(
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                child: imagePathViewModel.imagePath.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(50.0),
                                        child: CircularProgressIndicator(),
                                      )
                                    : PageView.builder(
                                        itemCount:
                                            imagePathViewModel.imagePath.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            child: Image.network(
                                                imagePathViewModel
                                                    .imagePath[index]),
                                          );
                                        },
                                      ),
                              ),
                              Text("브랜드: ${snapshot.data!.brand}"),
                              Text("모델명: ${snapshot.data!.model}"),
                              Text("가격: ${snapshot.data!.price}"),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
              ),

              // 현재 이미지 위치 (조그만한 원)----------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.map((image) {
                  int index = images.indexOf(image);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: CircleAvatar(
                        backgroundColor: index == selectedImageIndex
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        radius: 5,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),

              // 상품명 및 가격 -----------------------------------------------------
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Nike Running",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "90,000원",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 관심상품 등록 및 해제  --------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          bookmark = !bookmark;
                        });
                        print(bookmark);
                      },
                      icon: Icon(
                        bookmark
                            ? Icons.bookmark_outlined
                            : Icons.bookmark_outline,
                        size: 44,
                      ),
                    ),
                  ),
                ],
              ),

              // 제품설명 ---------------------------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  width: 360,
                  height: 130,
                  child: SingleChildScrollView(
                    // 글자수가 sized 박스를 넘어갈수도 있기 때문에 스크롤뷰로 해놈
                    child: Text(
                      "러닝 내내 최상의 쿠셔닝을 선사하는 Nike Running는 발 아래에 최고의 편안함을 선사해 언제든 러닝을 이어갈 수 있게 해줍니다. 러닝을 지속할 수 있게 도와주는 디자인으로, 지지력과 탄성이 매우 우수해 좋아하는 코스를 빠르게 달리고 돌아와 활력을 재충전하고 다음 러닝을 준비할 수 있습니다.",
                      softWrap: true,
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // 신발 색상선택 ---------------------------------------------------------
              SizedBox(
                height: 52, // 이미지 선택시 커지는 효과 때문에 밑에 버튼의 위치가 움직여서 사이즈를 고정시켜놈
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          const Text(
                            "color : ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: buildColorButton(Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: buildColorButton(Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: buildColorButton(Colors.red),
                          ),
                        ],
                      ),
                    ),

                    // 사이즈 선택---------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        children: [
                          selectedSize == null
                              ? const Text("")
                              : const Text(
                                  "size :",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                          TextButton(
                            onPressed: () {
                              showSizeBottomSheet(context);
                            },
                            child: Text(
                              selectedSize ?? "Choose size",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // 장바구니 / 구매하기 버튼 ---------------------------------------------
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        addToCart();
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        checkOut();
                      },
                      child: const Text("구매하기"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------------------------------------

  // 신발색상 선택 위젯
  Widget buildColorButton(Color color) {
    const double selectedSize = 30;
    const double unselectedSize = 20;
    String resultColor; // 선택한 색상을 문자로 출력하기 위해
    resultColor = "black"; // 기본값
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          if (selectedColor == Colors.white) {
            resultColor = "white";
          } else if (selectedColor == Colors.black) {
            resultColor = "black";
          } else {
            resultColor = "red";
          }
          print(resultColor);
        });
      },
      child: Container(
        width: selectedColor == color ? selectedSize : unselectedSize,
        height: selectedColor == color ? selectedSize : unselectedSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        // child: selectedColor == color
        //     ? const Icon(Icons.check, size: 20, color: Colors.grey)
        //     : null,
      ),
    );
  }

  // 사이즈 선택 위젯

  void showSizeBottomSheet(BuildContext context) {
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
                  Text('Select size',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(
                  16, // 버튼갯수
                  (int index) {
                    final size = (index * 5 + 220).toString();
                    final isSelected = size == selectedSize;

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSize = size;
                          print(selectedSize);
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
                      child: Text(size, style: const TextStyle(fontSize: 20)),
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

  // 장바구니 다이어로그창
  void addToCart() {
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
          content: const Text("해당제품을 장바구니에 담으시겠습니까?"),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 구매 다이어로그창
  void checkOut() {
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
          content: const Text("해당제품을 구매하러 가시겠습니까?"),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------------------------------------
  // backend
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이성연
  /// 만든이 :
  /// 내용 : shoe detail 정보 보여주기
  // Future<Shoe> selectModelNameData() {
  //   //
  // }
  /// Desc : 신발 이미지 가져오기
  /// Date : 2023.03.19
  /// Author : youngjin
  /// *** 이미지 프리뷰 너무 오래 걸림 (수정 필요할 듯) ***
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
        imagePathViewModel = ImagePathViewModel(imagePath: pathList);
      });
    }
  }
}
