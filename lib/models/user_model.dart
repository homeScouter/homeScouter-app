class UserModel {
  final String uid, email, name, phone, tapoCode;

  UserModel.fromJson(Map<String, dynamic> json)
    : uid = json['uid'],
      email = json['email'],
      name = json['name'],
      phone = json['phone'],
      tapoCode = json['tapoCode'];
}
