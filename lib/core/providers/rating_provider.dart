import 'package:flutter/foundation.dart';
import '../models/movie_rating.dart';
import '../repositories/rating_repository.dart';

class RatingProvider with ChangeNotifier {
  final RatingRepository _repository = RatingRepository();

  List<MovieRating> _ratings = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<MovieRating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchRatings() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _ratings = await _repository.getRatings();
    } catch (e) {
      _errorMessage = 'Gagal memuat data review dari database: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRating({
    required String movieId,
    required double rating,
    required String note,
    required String watchDate,
    required bool favorite,
  }) async {
    try {
      _errorMessage = '';
      final newRating = MovieRating(
        createdAt: DateTime.now().toIso8601String(),
        rating: rating,
        note: note,
        movieId: movieId,
        watchDate: watchDate,
        userId: 1,
        favorite: favorite,
      );
      await _repository.createRating(newRating);
      await fetchRatings();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan review ke database: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRating({
    required int id,
    required double rating,
    required String note,
    required String watchDate,
    required bool favorite,
  }) async {
    try {
      _errorMessage = '';
      final data = {
        'rating': rating,
        'note': note,
        'watch_date': watchDate,
        'favorite': favorite,
      };
      await _repository.editRating(id, data);
      await fetchRatings();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui review: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRating(int id) async {
    try {
      _errorMessage = '';
      await _repository.removeRating(id);
      await fetchRatings();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus review: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}