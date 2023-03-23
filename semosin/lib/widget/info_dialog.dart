import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowInfoDialog extends StatefulWidget {
  const ShowInfoDialog({super.key});

  @override
  State<ShowInfoDialog> createState() => _ShowInfoDialogState();
}

class _ShowInfoDialogState extends State<ShowInfoDialog> {
  Color selectColor = const Color.fromARGB(150, 199, 198, 198);
  Color unselectColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.006;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '앱 정보',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.44,
                  top: MediaQuery.of(context).size.height * 0.01,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.width * 0.06,
                    child: RawMaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.black45,
                        size: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '  앱 이름',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '세모신\n(세상의 모든 신발)',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '  개발자',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '권순형,이호식,신오수\n이영진,이상혁,이성연',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '  이메일',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    'saemosin\n@gmail.com',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '  취업',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    '성공 기원',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
