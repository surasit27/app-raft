class Confirm {
  DateTime? date;
  DateTime? datelast;
  int? price;
  String? deposit;
  String? userid;
  String? iDPro;
  String? raft;
  String? services;
  String? imagedeposit;
  String? imagepay;
  int? pay;
  String? pathfilepay;
  String? pathfile;

  Confirm(
      {this.date,
      this.datelast,
      this.price,
      this.deposit,
      this.userid,
      this.iDPro,
      this.raft,
      this.services,
      this.imagedeposit,
      this.imagepay,
      this.pathfilepay,
      this.pay,
      this.pathfile});

  factory Confirm.fromJson(Map<String, dynamic> json) => Confirm(
      date: DateTime.parse(json["date"]),
      datelast: DateTime.parse(json["datelast"]),
      price: json["price"],
      deposit: json["deposit"],
      userid: json["userid"],
      iDPro: json["iDPro"],
      raft: json["raft"],
      services: json["services"],
      imagedeposit: json["imagedeposit"],
      imagepay: json["imagepay"],
      pay: json["pay"],
      pathfilepay: json["pathfilepay"],
      pathfile: json["pathfile"]);

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "datelast": datelast!.toIso8601String(),
        "price": price,
        "deposit": deposit,
        "userid": userid,
        "iDPro": iDPro,
        "raft": raft,
        "services": services,
        "imagedeposit": imagedeposit,
        "imagepay": imagepay,
        "pay": pay,
        "pathfilepay": pathfilepay,
        "pathfile": pathfile
      };
}
