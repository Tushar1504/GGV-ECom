class Users {
  final int? userId;
  final String userName;
  final String password;

  Users({this.userId, required this.userName, required this.password});

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        userName: json["userName"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "userName": userName,
        "password": password,
      };
}
