import 'dart:convert';

ActivitysModel activitysModelFromJson(String str) =>
    ActivitysModel.fromJson(json.decode(str));

String activitysModelToJson(ActivitysModel data) => json.encode(data.toJson());

class ActivitysModel {
  ActivitysModel({
    required this.activityId,
    required this.activityName,
    required this.activityDetails,
    required this.activityImagePaht,
    required this.activityVideoPaht,
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

  String activityId;
  String activityName;
  String activityDetails;
  String activityImagePaht;
  String activityVideoPaht;
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

  factory ActivitysModel.fromJson(Map<String, dynamic> json) => ActivitysModel(
        activityId: json["activityId"],
        activityName: json["activityName"],
        activityDetails: json["activityDetails"],
        activityImagePaht: json["activityImagePaht"],
        activityVideoPaht: json["activityVideoPaht"],
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
        "activityId": activityId,
        "activityName": activityName,
        "activityDetails": activityDetails,
        "activityImagePaht": activityImagePaht,
        "activityVideoPaht": activityVideoPaht,
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
