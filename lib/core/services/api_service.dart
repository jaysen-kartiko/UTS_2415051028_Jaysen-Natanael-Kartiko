import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final baseUrl = dotenv.get('MOVIES_API_ENDPOINT');
  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data film dari server');
    }
  }
}