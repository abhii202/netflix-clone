import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global_session/global_session.dart';
import '../model/profile_model.dart';

class AccountApiService {
  Future<List<ProfileModel>> fetchProfiles() async {
    final postsDioId = SessionManager.userId;
    final url =
        "https://689098f9944bf437b59699b4.mockapi.io/posts_dio/$postsDioId/posts";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProfileModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch profiles.');
    }
  }
}
