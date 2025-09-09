import '../../login/models/users_model.dart';

class ProfileModel {
  final String id;
  final String postsDioId;
  final String name;
  final String image;
  final UserModel users;

  ProfileModel({
    required this.id,
    required this.postsDioId,
    required this.name,
    required this.image,
    required this.users,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      postsDioId: json['posts_dioId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      users: UserModel.fromJson(json['users'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posts_dioId': postsDioId,
      'name': name,
      'image': image,
      'users': users.toJson(),
    };
  }
}
