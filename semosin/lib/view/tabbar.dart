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

class _ShoesTabBarState extends State<ShoesTabBar>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  /// 날짜 : 2023.03.15
  /// 작성자 : 권순형
  /// 만든이 :
  /// 내용 : ShoesTabBarController 와 ShoesTabBar View 전체 화면
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller, // field 에 생성한 TabController 변수 사용
        children: const [
          ShoesList(),
          CartView(),
          FindShoes(),
          // ImageUpload(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: controller,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        tabs: const [
          SizedBox(
            height: 45,
            child: Text('신발 목록'),
          ),
          SizedBox(
            height: 45,
            child: Text('장바구니'),
          ),
          SizedBox(
            height: 45,
            child: Text('신발 찾기'),
          ),
          SizedBox(
            height: 45,
            child: Text('마이 페이지'),
          ),
        ],
      ),
    );
  }
}
