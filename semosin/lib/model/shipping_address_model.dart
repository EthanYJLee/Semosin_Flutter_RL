class ShippingAddressModel {
  final String name;
  final String address;
  final String detailAddress;
  final String phone;

  ShippingAddressModel(
      {required this.name,
      required this.address,
      required this.detailAddress,
      required this.phone});

  ShippingAddressModel.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        address = json['address'].toString(),
        detailAddress = json['detailAddress'].toString(),
        phone = json['phone'].toString();
}
