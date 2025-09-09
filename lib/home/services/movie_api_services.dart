import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/tmdb_api.dart';
import '../models/movie_model.dart';

class MovieRepository {
  Future<List<Movie>> fetchTrendingMovies() async {
    final url =
        "${TMDBConfig.baseUrl}/discover/movie?api_key=${TMDBConfig.apiKey}&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=true&page=1";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          return results.map((json) => Movie.fromJson(json)).toList();
        } else {
          debugPrint("No 'results' key in response, returning empty list");
          return [];
        }
      } else {
        debugPrint("Failed to fetch movies, status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching movies: $e");
      return [];
    }
  }

  Future<String?> fetchTrailerKey(int movieId) async {
    final url =
        "${TMDBConfig.baseUrl}/movie/$movieId/videos?api_key=${TMDBConfig.apiKey}&language=en-US";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) return null;

      final trailers = results.where((video) {
        final type = video['type']?.toString();
        final site = video['site']?.toString();
        return (type == "Trailer" || type == "Teaser") && site == "YouTube";
      }).toList();

      if (trailers.isEmpty) return null;

      return trailers.first['key'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<Movie?> fetchMovieDetails(int movieId) async {
    final url =
        "${TMDBConfig.baseUrl}/movie/$movieId?api_key=${TMDBConfig.apiKey}&language=en-US";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Movie.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
