class Favorites {
  late String shoeImageName;
  final String shoeModelName;
  final String shoeBrandName;

  Favorites({
    required this.shoeBrandName,
    required this.shoeModelName,
    required this.shoeImageName,
  });

  Favorites.fromJson(Map<String, dynamic> json)
      : shoeImageName = json['image'].toString(),
        shoeModelName = json['model'].toString(),
        shoeBrandName = json['brand'].toString();
}
