import '../models/movie_rating.dart';
import '../services/supabase_service.dart';

class RatingRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<List<MovieRating>> getRatings() async {
    return await _supabaseService.fetchMovieRatings();
  }

  Future<void> createRating(MovieRating rating) async {
    await _supabaseService.addRating(rating);
  }

  Future<void> editRating(int id, Map<String, dynamic> data) async {
    await _supabaseService.updateRating(id, data);
  }

  Future<void> removeRating(int id) async {
    await _supabaseService.deleteRating(id);
  }
}