class Cart {
  // final int checkStatus;
  final String cartNo;
  final String cartModelName;
  final String selectedSize;
  final String amount;
  final String price;
  final String image;
  final String color;
  final String initDate;
  Cart(
      {
      // required this.checkStatus,
      required this.cartNo,
      required this.cartModelName,
      required this.selectedSize,
      required this.amount,
      required this.price,
      required this.image,
      required this.color,
      required this.initDate});

  Cart.fromJson(Map<String, dynamic> json)
      :
        // checkStatus = int.parse(json['checkStatus'].toString()),
        cartNo = json['cartNo'].toString(),
        cartModelName = json['cartModelName'].toString(),
        selectedSize = json['selectedSize'].toString(),
        amount = json['amount'].toString(),
        price = json['price'].toString(),
        image = json['image'].toString(),
        color = json['color'].toString(),
        initDate = json['initDate'].toString();
}
