class ShoeViewModel {
  late String shoeImageName;
  final String shoeModelName;
  final String shoeBrandName;
  final int likeNum;
  final int shoePrice;

  ShoeViewModel({
    required this.shoeBrandName,
    required this.shoeModelName,
    required this.shoeImageName,
    required this.shoePrice,
    required this.likeNum,
  });

  ShoeViewModel.fromJson(Map<String, dynamic> json)
      : shoeImageName = json['images'][0].toString(),
        shoeModelName = json['model'].toString(),
        shoeBrandName = json['brand'].toString(),
        likeNum = int.parse(json['like'].toString()),
        shoePrice = int.parse(json['price'].toString());
}
