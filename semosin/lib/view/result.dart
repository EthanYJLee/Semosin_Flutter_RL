import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class Result extends StatelessWidget {
  final XFile image;
  const Result({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload한 이미지 보여주기
            Container(
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
                            ? Image.network(image.path)
                            : Image.file(File(image.path)),
                      ),
                    ],
                  );
                },
              ),
            ),
            // 예측한 신발의 모델 결과
            Text('@@신발일 확률 58000%'),
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
        ),
      ),
    );
  }
}
