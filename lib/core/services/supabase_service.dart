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

  Future<void> addRating(MovieRating rating) async {
    await _client.from('movie_ratings').insert(rating.toJson());
  }
  
  Future<void> updateRating(int id, Map<String, dynamic> data) async {
    await _client.from('movie_ratings').update(data).eq('id', id);
  }

Future<void> deleteRating(int id) async {
    await _client.from('movie_ratings').delete().eq('id', id);
}
 Future<UserProfile> fetchUserProfile(int userId) async {
  final response = await _client
      .from('users')
      .select()
      .eq('id', userId)
      .single();
  return UserProfile.fromJson(response);
}
}