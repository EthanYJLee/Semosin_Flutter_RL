class Favorites {
  late String shoeImageName;
  final String shoeModelName;
  final String shoeBrandName;
  final int price;
  final String initdate;

  Favorites({
    required this.shoeBrandName,
    required this.shoeModelName,
    required this.shoeImageName,
    required this.price,
    required this.initdate,
  });

  Favorites.fromJson(Map<String, dynamic> json)
      : shoeImageName = json['image'].toString(),
        shoeModelName = json['model'].toString(),
        shoeBrandName = json['brand'].toString(),
        price = json['price'],
        initdate = json['initdate'].toString();
}

class Testyo {
  final String docId2;
  final String initdate;

  Testyo({
    required this.docId2,
    required this.initdate,
  });

  Testyo.fromJson(Map<String, dynamic> json)
      : docId2 = json['docId2'].toString(),
        initdate = json['initdate'].toString();
}
