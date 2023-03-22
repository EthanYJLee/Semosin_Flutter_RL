import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupCard extends StatelessWidget {
  /// Desc : ShoeDetail에서 상품 상세정보 (제조사, 제조국, 색상, 소재, 굽높이 보여주는 Popup Card)
  /// Date : 2023.03.20
  /// Author : youngjin
  const PopupCard({
    Key? key,
    required this.maker,
    required this.country,
    required this.color,
    required this.material,
    required this.height,
  }) : super(key: key);

  final String maker;
  final String country;
  final String color;
  final String material;
  final String height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Hero(
              tag: maker,
              createRectTween: (begin, end) {
                return RectTween(begin: begin, end: end);
              },
              child: Material(
                color: Color.fromARGB(255, 240, 239, 239),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '상품정보제공 고시',
                          style: TextStyle(fontSize: 22),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Text('제조사: $maker'),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Text('제조국가: $country'),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Text('색상코드: $color'),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Text('소재: $material'),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Text('굽높이: $height'),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 142, 136, 136)),
                              child: const Text(
                                '닫기',
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
