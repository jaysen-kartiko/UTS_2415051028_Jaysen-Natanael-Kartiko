import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieProvider with ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _movies = await _repository.getMovies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}