class OrderRaftModel {
  OrderRaftModel({
    required this.orderDetailsPrice,
    required this.raftName,
    required this.raftPrice,
    required this.raftImage,
  });

  int orderDetailsPrice;
  String raftName;
  int raftPrice;
  String raftImage;

  factory OrderRaftModel.fromJson(Map<String, dynamic> json) => OrderRaftModel(
        orderDetailsPrice: json["orderDetails_price"],
        raftName: json["raftName"],
        raftPrice: json["raftPrice"],
        raftImage: json["raftImage"],
      );

  Map<String, dynamic> toJson() => {
        "orderDetails_price": orderDetailsPrice,
        "raftName": raftName,
        "raftPrice": raftPrice,
        "raftImage": raftImage,
      };
}
