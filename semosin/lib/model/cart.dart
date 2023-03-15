class Cart {
  final int checkStatus;
  final String cartNo;
  final String cartModelName;
  final String selectedSize;
  final int amount;

  Cart(
      {required this.checkStatus,
      required this.cartNo,
      required this.cartModelName,
      required this.selectedSize,
      required this.amount});

  Cart.fromJson(Map<String, dynamic> json)
      : checkStatus = int.parse(json['checkStatus'].toString()),
        cartNo = json['cartNo'].toString(),
        cartModelName = json['cartModelName'].toString(),
        selectedSize = json['selectedSize'].toString(),
        amount = int.parse(json['amount'].toString());
}
