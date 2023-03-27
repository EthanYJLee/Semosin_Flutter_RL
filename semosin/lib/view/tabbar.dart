import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semosin/main.dart';
import 'package:semosin/view/cartview.dart';
import 'package:semosin/view/findshoes.dart';
import 'package:semosin/view/image_upload.dart';
import 'package:semosin/view/mypage.dart';
import 'package:semosin/view/shoeslist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoesTabBar extends StatefulWidget {
  const ShoesTabBar({super.key});

  @override
  State<ShoesTabBar> createState() => _ShoesTabBarState();
}

class _ShoesTabBarState extends State<ShoesTabBar> {
  late int currentIndex;

  final List<Widget> children = const [
    ShoesList(),
    CartView(),
    ImageUpload(),
    MyPage(),
  ];

  late List<bool> onSelected;

  /// 날짜 : 2023.03.15
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : bottom navigation bar
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentIndex = 0;
    onSelected = [true, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              SharedPreferences.getInstance().then((value) {
                final pref = value;
                pref.remove("saemosin-auto-login-status");

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const MyApp()));
              });
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
          changeOnselected(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: onSelected[0]
                ? const Icon(CupertinoIcons.square_list_fill)
                : const Icon(CupertinoIcons.square_list),
            label: "신발 목록",
          ),
          BottomNavigationBarItem(
            icon: onSelected[1]
                ? const Icon(CupertinoIcons.cart_fill)
                : const Icon(CupertinoIcons.cart),
            label: "장바구니",
          ),
          BottomNavigationBarItem(
            icon: onSelected[2]
                ? const Icon(CupertinoIcons.camera_fill)
                : const Icon(CupertinoIcons.camera),
            label: "신발 예측",
          ),
          BottomNavigationBarItem(
            icon: onSelected[3]
                ? const Icon(CupertinoIcons.person_fill)
                : const Icon(CupertinoIcons.person),
            label: "마이 페이지",
          ),
        ],
      ),
    );
  }

  /// 날짜 : 2023.03.21
  /// 만든이 : 권순형
  /// 설명 : tab 선택시 icon 이미지 채우기
  changeOnselected(int index) {
    for (var i = 0; i < 4; i++) {
      if (i == index) {
        onSelected[i] = true;
      } else {
        onSelected[i] = false;
      }
    }

    setState(() {});
  }
}
