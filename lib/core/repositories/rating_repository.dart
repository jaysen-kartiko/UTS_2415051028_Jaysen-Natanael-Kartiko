import '../models/movie_rating.dart';
import '../services/supabase_service.dart';

class RatingRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<List<MovieRating>> getRatings() async {
    return await _supabaseService.fetchMovieRatings();
  }


}