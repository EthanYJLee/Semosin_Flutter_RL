class Shoe {
  final List<String> images;
  final String model;
  final String brand;
  final String price;
  final String material;
  final String height;
  final List<String> colors;
  final Map<String, int> sizes;
  final String maker;
  final String country;
  final String method;
  final String initdate;

  Shoe({
    required this.images,
    required this.model,
    required this.brand,
    required this.price,
    required this.material,
    required this.height,
    required this.colors,
    required this.sizes,
    required this.maker,
    required this.country,
    required this.method,
    required this.initdate,
  });

  Shoe.fromJson(Map<String, dynamic> json)
      : images = json['images'].cast<String>(),
        model = json['model'].toString(),
        brand = json['brand'].toString(),
        price = json['price'].toString(),
        material = ['material'].toString(),
        height = json['height'].toString(),
        colors = json['colors'].cast<String>(),
        sizes = json['sizes'].cast<String, int>(),
        maker = json['maker'].toString(),
        country = json['country'].toString(),
        method = json['method'].toString(),
        initdate = json['initdate'].toString();
}
