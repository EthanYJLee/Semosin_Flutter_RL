import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:semosin/view/image_upload.dart';
import 'package:semosin/view/tabbar.dart';

import '../services/flask_predict.dart';
import '../widget/myappbar.dart';

class Result extends StatefulWidget {
  final XFile image;
  const Result({super.key, required this.image});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> with TickerProviderStateMixin {
  late String result = '';
  late AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          });
    controller.repeat(reverse: true);
    onUploadImage();
    super.initState();
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
      appBar: const MyAppBar(title: "이미지 결과"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload한 이미지 보여주기
            SizedBox(
              height: 320,
              width: 250,
              child: Center(
                child: Semantics(
                  label: 'selected_image',
                  child: Image.file(
                    File(widget.image.path),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            (result == "")
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("해당 제품을 예측중입니다."),
                  )
                : const Text(""),
            //예측한 신발의 모델 결과
            (result == "")
                ? SizedBox(
                    width: 300,
                    child: LinearProgressIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      value: controller.value,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(300, 50),
                      ),
                      onPressed: () {
                        predictCompleted(context);
                      },
                      child: const Text("결과확인하기"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// Desc : 예측 끝나면 Indicator dispose 하고 결과값 출력
  /// Date : 2023.03.18
  /// Author : youngjin
  void predictCompleted(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                '예측결과',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.file(File(widget.image.path)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                result == "입력하신 이미지가 상당히 잘못 되었습니다."
                    ? "입력하신 이미지가 상당히 잘못 되었습니다."
                    : "해당 이미지는 $result 입니다.",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ShoesTabBar(),
                          fullscreenDialog: true,
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("홈으로"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      //
                    },
                    child: const Text("제품 보러가기"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// -------------------- FUNCTIONS --------------------
  /// Desc : '모델 예측하기' 버튼 눌렀을 때 Image Flask 서버로 넘기기 + 예측
  /// Date : 2023.03.18
  /// Author : youngjin
  /// 수정이 : 권순형
  /// 수정내용 : flask service 클래스로 분리
  onUploadImage() async {
    final FlaskPredict predict = FlaskPredict();
    var flaskResult = await predict.predictImage(widget.image.path);

    if (flaskResult[1]) {
      setState(() {
        result = "입력하신 이미지가 상당히 잘못 되었습니다.";
      });
    } else {
      setState(() {
        result = flaskResult[0];
      });
    }
  }
}
