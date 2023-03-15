import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:semosin/firebase_options.dart';
import 'package:semosin/view/signup.dart';
import 'package:semosin/view/welcome.dart';

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
  /// 만든이 :
  /// 내용 : firebase auth로 login 했는지 안했는지 체크 하기
  /// 상세 내용 : login 한적 있으면 Home , 없으면 Welcome
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Signup(),
    );
  }
}
