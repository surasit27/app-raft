class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.userPassword,
    this.userTel,
    this.userEmail,
  });

  String? userId;
  String? userName;
  String? userPassword;
  String? userTel;
  String? userEmail;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        userName: json["userName"],
        userPassword: json["userPassword"],
        userTel: json["userTel"],
        userEmail: json["userEmail"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "userPassword": userPassword,
        "userTel": userTel,
        "userEmail": userEmail,
      };
}
