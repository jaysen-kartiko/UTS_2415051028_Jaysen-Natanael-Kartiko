import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie_rating.dart';
import '../models/user_profile.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MovieRating>> fetchMovieRatings() async {
    final response = await _client
        .from('movie_ratings')
        .select()
        .order('created_at', ascending: false);
    
    final List<dynamic> data = response;
    return data.map((json) => MovieRating.fromJson(json)).toList();
  }




}