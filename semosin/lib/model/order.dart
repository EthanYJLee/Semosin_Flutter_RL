class Order {
  // ---------- 배송할 대상 고객의 정보 ----------
  final String name;
  final String phone;
  final String postcode;
  final String address;
  final String addressDetail;
  final String deliveryRequest;
  // ---------- 주문 정보 ----------
  final String orderNo;
  final String orderModel;
  final String orderedSize;
  final int amount;
  final String orderDate;
  final int orderStatus;
  final int cancelStatus;
  String? cancelNo;
  final int refundStatus;
  String? refundNo;
  final int exchangeStatus;
  String? exchangeNo;
  final String changeStatusDate;
  String? changeStatusDoneDate;

  Order({
    required this.name,
    required this.phone,
    required this.postcode,
    required this.address,
    required this.addressDetail,
    required this.deliveryRequest,
    required this.orderNo,
    required this.orderModel,
    required this.orderedSize,
    required this.amount,
    required this.orderDate,
    required this.orderStatus,
    required this.cancelStatus,
    this.cancelNo,
    required this.refundStatus,
    this.refundNo,
    required this.exchangeStatus,
    this.exchangeNo,
    required this.changeStatusDate,
    this.changeStatusDoneDate,
  });

  Order.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        phone = json['phone'].toString(),
        postcode = json['postcode'].toString(),
        address = json['address'].toString(),
        addressDetail = json['addressDetail'].toString(),
        deliveryRequest = json['deliveryRequest'].toString(),
        orderNo = json['orderNo'].toString(),
        orderModel = json['orderModel'].toString(),
        orderedSize = json['orderedSize'].toString(),
        amount = int.parse(['amount'].toString()),
        orderDate = json['orderDate'].toString(),
        orderStatus = int.parse(json['orderStatus'].toString()),
        cancelStatus = int.parse(json['cancelStatus'].toString()),
        cancelNo = json['cancelNo'].toString(),
        refundStatus = int.parse(json['refundStatus'].toString()),
        refundNo = json['refundNo'].toString(),
        exchangeStatus = int.parse(json['exchangeStatus'].toString()),
        exchangeNo = json['exchangeNo'].toString(),
        changeStatusDate = json['changeStatusDate'].toString(),
        changeStatusDoneDate = json['changeStatusDoneDate'].toString();
}
