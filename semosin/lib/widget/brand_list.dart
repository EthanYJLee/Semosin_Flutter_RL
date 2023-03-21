import 'dart:async';

import 'package:flutter/material.dart';
import 'package:semosin/model/brand_list.dart';

final brandStreamController = StreamController<String>();
List brand_list = makeBrandList().imgitems;

Widget BrandHorizontalList(
    BuildContext context, StreamController streamController) {
  return Center(
    // children: [
    child: SizedBox(
      height: 58,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // itemCount: data.length,
        itemCount: brand_list.length,
        itemBuilder: (context, index) {
          return brandList(context, index, streamController);
        },
      ),
    ),
    // ],
  );
}

Widget brandList(
    BuildContext context, int index, StreamController streamController) {
  List<String> brandNameList = ['all', '나이키', '컨버스', '아디다스', '푸마', '조던', '아식스'];
  return Container(
    margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
    // padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      color: Colors.grey[200],
    ),
    child: InkWell(
      onTap: () {
        streamController.add(brandNameList[index]);
      },
      child: Image.network(
        brand_list[index].image,
        fit: BoxFit.fill,
      ),
    ),
  );
} // cardBuild END
