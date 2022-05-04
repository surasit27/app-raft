class OrderServicesModel {
  OrderServicesModel({
    required this.servicesName,
    required this.servicesPrice,
    required this.servicesImagePaht,
  });

  String servicesName;
  int servicesPrice;
  String servicesImagePaht;

  factory OrderServicesModel.fromJson(Map<String, dynamic> json) =>
      OrderServicesModel(
        servicesName: json["servicesName"],
        servicesPrice: json["servicesPrice"],
        servicesImagePaht: json["servicesImagePaht"],
      );

  Map<String, dynamic> toJson() => {
        "servicesName": servicesName,
        "servicesPrice": servicesPrice,
        "servicesImagePaht": servicesImagePaht,
      };
}
