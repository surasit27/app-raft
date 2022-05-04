class BusinessesModel {
  BusinessesModel({
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

  factory BusinessesModel.fromJson(Map<String, dynamic> json) =>
      BusinessesModel(
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
