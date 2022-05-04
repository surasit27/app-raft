class PromotionModel {
  PromotionModel({
    required this.promotionId,
    required this.promotionName,
    required this.promotionImage,
    required this.promotionDetails,
    required this.promotionDiscoun,
    required this.promotionStartdate,
    required this.promotionLastdate,
    required this.promotionStatusId,
    required this.spromotionName,
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

  String promotionId;
  String promotionName;
  String promotionImage;
  String promotionDetails;
  int promotionDiscoun;
  DateTime promotionStartdate;
  DateTime promotionLastdate;
  int promotionStatusId;
  String spromotionName;
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

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        promotionId: json["promotionId"],
        promotionName: json["promotionName"],
        promotionImage: json["promotionImage"],
        promotionDetails: json["promotionDetails"],
        promotionDiscoun: json["promotionDiscoun"],
        promotionStartdate: DateTime.parse(json["promotionStartdate"]),
        promotionLastdate: DateTime.parse(json["promotionLastdate"]),
        promotionStatusId: json["promotionStatusId"],
        spromotionName: json["spromotionName"],
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
        "promotionId": promotionId,
        "promotionName": promotionName,
        "promotionImage": promotionImage,
        "promotionDetails": promotionDetails,
        "promotionDiscoun": promotionDiscoun,
        "promotionStartdate": promotionStartdate.toIso8601String(),
        "promotionLastdate": promotionLastdate.toIso8601String(),
        "promotionStatusId": promotionStatusId,
        "spromotionName": spromotionName,
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
