class UserModel {
  final String uid, email, name, phone, tapoCode, fcmToken;

  UserModel.fromJson(Map<String, dynamic> json)
    : uid = json['uid'] as String,
      email = json['email'] as String,
      name = json['name'] as String,
      phone = json['phone'] as String,
      tapoCode = json['tapoCode'] as String,
      fcmToken = json['fcmToken'] as String;
}
