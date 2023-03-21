import 'package:flutter/material.dart';

class NotReady extends StatelessWidget {
  const NotReady({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
          'https://www.geochang.go.kr/portal/popup/20190111/20190111.gif'),
    );
  }
}
