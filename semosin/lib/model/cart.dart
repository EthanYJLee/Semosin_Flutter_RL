class Cart {
  bool cartStatus;
  final String brandName;
  final String modelName;
  String selectedSize;
  String amount;
  final String price;
  final String image;
  String color;
  final String initDate;
  final String documentId;

  Cart(
      {required this.cartStatus,
      required this.brandName,
      required this.modelName,
      required this.selectedSize,
      required this.amount,
      required this.price,
      required this.image,
      required this.color,
      required this.initDate,
      required this.documentId});

  Cart.fromJson(Map<String, dynamic> json)
      // : cartStatus = json['cartStatus'].toString(),
      : cartStatus = json['cartStatus'],
        brandName = json['brandName'].toString(),
        modelName = json['modelName'].toString(),
        selectedSize = json['selectedSize'].toString(),
        amount = json['amount'].toString(),
        price = json['price'].toString(),
        image = json['image'].toString(),
        color = json['color'].toString(),
        initDate = json['initDate'].toString(),
        documentId = json['documentId'].toString();
}
