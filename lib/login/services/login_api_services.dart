import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global_session/global_session.dart';
import '../models/users_model.dart';

class LoginApiService {
  final String baseUrl =
      "https://689098f9944bf437b59699b4.mockapi.io/posts_dio";

  Future<UserModel> login(String email, String password) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final user = data.cast<Map<String, dynamic>>().firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        throw Exception('Invalid credentials.');
      }
      final loggedInUser = UserModel.fromJson(user);

      SessionManager.userId = loggedInUser.id;

      return loggedInUser;
    } else {
      throw Exception('Server error.');
    }
  }
}
