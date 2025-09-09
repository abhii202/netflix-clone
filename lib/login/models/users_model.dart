class UserModel {
  final String id;
  final String email;
  final String password;
  UserModel({required this.id, required this.email, required this.password});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      id: json['id'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'id': id};
  }
}
