import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupCard extends StatelessWidget {
  const PopupCard({
    Key? key,
    required this.maker,
    required this.country,
    required this.material,
    required this.height,
  }) : super(key: key);

  final String maker;
  final String country;
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
