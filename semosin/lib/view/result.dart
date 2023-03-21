import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semosin/services/flask_predict.dart';

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
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          });
    controller.repeat(reverse: true);

    onUploadImage();
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
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload한 이미지 보여주기
            SizedBox(
              height: 350,
              width: 350,
              child: GridView.builder(
                itemCount: 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 1개의 행에 보여줄 item 개수
                  childAspectRatio: 1, // item 의 가로 1, 세로 1 의 비율 (1/1)
                  mainAxisSpacing: 10, // 수평 Padding
                  crossAxisSpacing: 10, // 수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'selected_image',
                        child: kIsWeb
                            ? Image.network(widget.image.path)
                            : Image.file(File(widget.image.path)),
                      ),
                    ],
                  );
                },
              ),
            ),
            // 예측한 신발의 모델 결과
            (result == '')
                ? SizedBox(
                    width: 300,
                    child: LinearProgressIndicator(
                      value: controller.value,
                    ),
                  )
                : predictCompleted()
          ],
        ),
      ),
    );
  }

  /// Desc : 예측 끝나면 Indicator dispose 하고 결과값 출력
  /// Date : 2023.03.18
  /// Author : youngjin
  Widget predictCompleted() {
    return Column(
      children: [
        Text(result),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: const [
                    Icon(Icons.backspace_rounded),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('돌아가기'),
                    ),
                  ],
                )),
            TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.shop),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '구매하러 가기',
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
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
