 import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class WatchlistProvider with ChangeNotifier {
  final List<Movie> _watchlist = [];

  List<Movie> get watchlist => _watchlist;

  bool isWatchlisted(Movie movie) {
    return _watchlist.any((item) => item.id == movie.id);
  }

  void toggleWatchlist(Movie movie) {
    if (isWatchlisted(movie)) {
      _watchlist.removeWhere((item) => item.id == movie.id);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
  }
}