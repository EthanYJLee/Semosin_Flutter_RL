import 'package:flutter/material.dart';

/// 날짜 :2023.03.15
/// 작성자 : 이호식
/// 만든이 : 이호식
/// 내용 : main list 에서 불러올 brand list
class ImageCarditem {
  String image;
  String brandName;
  ImageCarditem({required this.image, required this.brandName});
}

class makeBrandList {
  List imgitems = [
    ImageCarditem(
      image:
          'https://www.coolgenerator.com/Data/Textdesign/202303/d4f228396fc5c3e35f6503f05f6d6745.png',
      brandName: "",
    ),
    ImageCarditem(
      image:
          "https://github.com/LeeHosik/Image/blob/main/brand/nike%20small.png?raw=true",
      brandName: '나이키',
    ),
    ImageCarditem(
      image:
          "https://github.com/LeeHosik/Image/blob/main/brand/converse.png?raw=true",
      brandName: '컨버스',
    ),
    ImageCarditem(
      image:
          "https://github.com/LeeHosik/Image/blob/main/brand/adidas.png?raw=true",
      brandName: '아디다스',
    ),
    ImageCarditem(
      image:
          "https://w7.pngwing.com/pngs/268/793/png-transparent-puma-logo-reebok-reebok-text-carnivoran-dog-like-mammal.png",
      brandName: '푸마',
    ),
    ImageCarditem(
      image:
          "https://w7.pngwing.com/pngs/898/154/png-transparent-jumpman-air-jordan-nike-logo-nike.png",
      brandName: '조던',
    ),
    ImageCarditem(
      image:
          "https://w7.pngwing.com/pngs/961/378/png-transparent-asics-adidas-sneakers-logo-shoe-adidas-text-brand-symbol-thumbnail.png",
      brandName: '아식스',
    )
  ];
}
