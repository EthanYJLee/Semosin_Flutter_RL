import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:semosin/firebase_options.dart';
import 'package:semosin/view/tabbar.dart';
import 'package:semosin/view/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// 날짜 :2023.03.13
  /// 작성자 : 권순형
  /// 만든이 : 이영진
  /// 작성일 : 2023.03.15
  /// 내용 : firebase auth로 login 했는지 안했는지 체크 하기
  /// 상세 내용 : login 한적 있으면 Home , 없으면 Welcome
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // 저장된 토큰 유무를 확인한 후 결과에 따라 존재한다면 Home으로, 없다면 로그인-회원가입으로 이동
      home: StreamBuilder<bool>(
        stream: isDataInSharedPreferece(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            if (userSnapshot.data!) {
              return const ShoesTabBar();
            } else {
              return const Welcome();
            }
          } else {
            return const Welcome();
          }
        },
      ),
    );
  }

  Stream<bool> isDataInSharedPreferece() async* {
    final pref = await SharedPreferences.getInstance();
    if (pref.getString('uid') == null || pref.getString('uid')!.isEmpty) {
      yield false;
    } else {
      yield true;
    }
  }
}
