import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie_rating.dart';
import '../models/user_profile.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MovieRating>> fetchMovieRatings() async {
    try {
      final response = await _client
          .from('movie_ratings')
          .select()
          .order('created_at', ascending: false);
      
      final List<dynamic> data = response;
      return data.map((json) => MovieRating.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kesalahan database: Gagal memuat daftar review.');
    }
  }

  Future<void> addRating(MovieRating rating) async {
    try {
      await _client.from('movie_ratings').insert(rating.toJson());
    } catch (e) {
      throw Exception('Kesalahan database: Gagal menyimpan review.');
    }
  }

  Future<void> updateRating(int id, Map<String, dynamic> data) async {
    try {
      await _client.from('movie_ratings').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Kesalahan database: Gagal memperbarui review.');
    }
  }

  Future<void> deleteRating(int id) async {
    try {
      await _client.from('movie_ratings').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kesalahan database: Gagal menghapus review.');
    }
  }

  Future<UserProfile> fetchUserProfile(int userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Kesalahan database: Gagal memuat profil pengguna.');
    }
  }
}