class ServicesModel {
  ServicesModel({
    required this.servicesId,
    required this.servicesName,
    required this.servicesImagePaht,
    required this.servicesPrice,
    required this.servicesVedioPaht,
    required this.servicesDetails,
    required this.businessId,
    required this.businessName,
    required this.businessTel,
    required this.businessEmail,
    required this.businessIdline,
    required this.businessBank,
    required this.businessAccountnumber,
    required this.businessAddress,
    required this.businessDistrict,
    required this.businessProvince,
    required this.businessSubdistrict,
    required this.businessZipcode,
  });

  String servicesId;
  String servicesName;
  String servicesImagePaht;
  int servicesPrice;
  String servicesVedioPaht;
  String servicesDetails;
  String businessId;
  String businessName;
  String businessTel;
  String businessEmail;
  String businessIdline;
  String businessBank;
  String businessAccountnumber;
  String businessAddress;
  String businessDistrict;
  String businessProvince;
  String businessSubdistrict;
  String businessZipcode;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        servicesId: json["servicesId"],
        servicesName: json["servicesName"],
        servicesImagePaht: json["servicesImagePaht"],
        servicesPrice: json["servicesPrice"],
        servicesVedioPaht: json["servicesVedioPaht"],
        servicesDetails: json["servicesDetails"],
        businessId: json["businessId"],
        businessName: json["businessName"],
        businessTel: json["businessTel"],
        businessEmail: json["businessEmail"],
        businessIdline: json["businessIdline"],
        businessBank: json["businessBank"],
        businessAccountnumber: json["businessAccountnumber"],
        businessAddress: json["businessAddress"],
        businessDistrict: json["businessDistrict"],
        businessProvince: json["businessProvince"],
        businessSubdistrict: json["businessSubdistrict"],
        businessZipcode: json["businessZipcode"],
      );

  Map<String, dynamic> toJson() => {
        "servicesId": servicesId,
        "servicesName": servicesName,
        "servicesImagePaht": servicesImagePaht,
        "servicesPrice": servicesPrice,
        "servicesVedioPaht": servicesVedioPaht,
        "servicesDetails": servicesDetails,
        "businessId": businessId,
        "businessName": businessName,
        "businessTel": businessTel,
        "businessEmail": businessEmail,
        "businessIdline": businessIdline,
        "businessBank": businessBank,
        "businessAccountnumber": businessAccountnumber,
        "businessAddress": businessAddress,
        "businessDistrict": businessDistrict,
        "businessProvince": businessProvince,
        "businessSubdistrict": businessSubdistrict,
        "businessZipcode": businessZipcode,
      };
}
