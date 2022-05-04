class OrderModel {
  OrderModel({
    this.userId,
    this.userName,
    this.orderId,
    this.orderDate,
    this.orderLastdate,
    this.orderPrice,
    this.orderImageDeposit,
    this.orderDeposit,
    this.orderImagePay,
    this.orderPay,
    this.sorderId,
    this.sorderName,
    this.promotionName,
    this.promotionImage,
    this.promotionDiscoun,
    this.businessId,
    this.promotionId,
    this.businessName,
    this.businessTel,
    this.businessEmail,
    this.businessIdline,
    this.businessBank,
    this.businessAccountnumber,
    this.businessAddress,
    this.businessDistrict,
    this.businessProvince,
    this.businessSubdistrict,
    this.businessZipcode,
  });

  String? userId;
  String? userName;
  String? orderId;
  DateTime? orderDate;
  DateTime? orderLastdate;
  int? orderPrice;
  String? orderImageDeposit;
  int? orderDeposit;
  String? orderImagePay;
  int? orderPay;
  int? sorderId;
  String? sorderName;
  String? promotionId;
  String? promotionName;
  String? promotionImage;
  int? promotionDiscoun;
  String? businessId;
  String? businessName;
  String? businessTel;
  String? businessEmail;
  String? businessIdline;
  String? businessBank;
  String? businessAccountnumber;
  String? businessAddress;
  String? businessDistrict;
  String? businessProvince;
  String? businessSubdistrict;
  String? businessZipcode;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        userId: json["userId"],
        userName: json["userName"],
        orderId: json["orderId"],
        orderDate: DateTime.parse(json["orderDate"]),
        orderLastdate: DateTime.parse(json["orderLastdate"]),
        orderPrice: json["orderPrice"],
        orderImageDeposit: json["orderImageDeposit"],
        orderDeposit: json["orderDeposit"],
        orderImagePay: json["orderImagePay"],
        orderPay: json["orderPay"],
        sorderId: json["sorderId"],
        sorderName: json["sorderName"],
        promotionId: json["promotionId"],
        promotionName: json["promotionName"],
        promotionImage: json["promotionImage"],
        promotionDiscoun: json["promotionDiscoun"],
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
        "userId": userId,
        "userName": userName,
        "orderId": orderId,
        "orderDate": orderDate?.toIso8601String(),
        "orderLastdate": orderLastdate?.toIso8601String(),
        "orderPrice": orderPrice,
        "orderImageDeposit": orderImageDeposit,
        "orderDeposit": orderDeposit,
        "orderImagePay": orderImagePay,
        "orderPay": orderPay,
        "sorderId": sorderId,
        "sorderName": sorderName,
        "promotionId": promotionId,
        "promotionName": promotionName,
        "promotionImage": promotionImage,
        "promotionDiscoun": promotionDiscoun,
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
