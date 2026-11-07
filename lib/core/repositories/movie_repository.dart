import '../models/movie.dart';
import '../services/api_service.dart';

class MovieRepository {
  final ApiService apiService = ApiService();

  Future<List<Movie>> getMovies() async {
    return await apiService.fetchMovies();
  }
}