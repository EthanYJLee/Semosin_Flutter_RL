class Order {
  final String orderNo;
  final String orderModel;
  final String orderedSize;
  final int amount;
  final String orderDate;
  final int orderStatus;
  final int cancelStatus;
  final String cancelNo;
  final int refundStatus;
  final String refundNo;
  final int exchangeStatus;
  final String exchangeNo;
  final String changeStatusDate;
  final String changeStatusDoneDate;

  Order({
    required this.orderNo,
    required this.orderModel,
    required this.orderedSize,
    required this.amount,
    required this.orderDate,
    required this.orderStatus,
    required this.cancelStatus,
    required this.cancelNo,
    required this.refundStatus,
    required this.refundNo,
    required this.exchangeStatus,
    required this.exchangeNo,
    required this.changeStatusDate,
    required this.changeStatusDoneDate,
  });

  Order.fromJson(Map<String, dynamic> json)
      : orderNo = json['orderNo'].toString(),
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
