class RaftServiceModel {
  RaftServiceModel({
    required this.detailservicesId,
    required this.servicesId,
    required this.servicesName,
    required this.servicesPrice,
    required this.servicesImagePaht,
  });

  String detailservicesId;
  String servicesId;
  String servicesName;
  int servicesPrice;
  String servicesImagePaht;

  factory RaftServiceModel.fromJson(Map<String, dynamic> json) =>
      RaftServiceModel(
        detailservicesId: json["detailservicesId"],
        servicesId: json["servicesId"],
        servicesName: json["servicesName"],
        servicesPrice: json["servicesPrice"],
        servicesImagePaht: json["servicesImagePaht"],
      );

  Map<String, dynamic> toJson() => {
        "detailservicesId": detailservicesId,
        "servicesId": servicesId,
        "servicesName": servicesName,
        "servicesPrice": servicesPrice,
        "servicesImagePaht": servicesImagePaht,
      };
}
