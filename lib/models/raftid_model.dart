class RaftIdModel {
  RaftIdModel({
    required this.raftId,
    required this.raftName,
    required this.raftDetails,
    required this.raftPrice,
    required this.raftImage,
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

  String raftId;
  String raftName;
  String raftDetails;
  int raftPrice;
  String raftImage;
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

  factory RaftIdModel.fromJson(Map<String, dynamic> json) => RaftIdModel(
        raftId: json["raftId"],
        raftName: json["raftName"],
        raftDetails: json["raftDetails"],
        raftPrice: json["raftPrice"],
        raftImage: json["raftImage"],
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
        "raftId": raftId,
        "raftName": raftName,
        "raftDetails": raftDetails,
        "raftPrice": raftPrice,
        "raftImage": raftImage,
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
