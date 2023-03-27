class ShippingAddressModel {
  final String documentId;
  final String name;
  final String postcode;
  final String address;
  final String addressDetail;
  final String phone;

  ShippingAddressModel(
      {required this.documentId,
      required this.name,
      required this.postcode,
      required this.address,
      required this.addressDetail,
      required this.phone});

  ShippingAddressModel.fromJson(Map<String, dynamic> json)
      : documentId = json['documentId'].toString(),
        name = json['name'].toString(),
        postcode = json['postcode'].toString(),
        address = json['address'].toString(),
        addressDetail = json['addressDetail'].toString(),
        phone = json['phone'].toString();
}
