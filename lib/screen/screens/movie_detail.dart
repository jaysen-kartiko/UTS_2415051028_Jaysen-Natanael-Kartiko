import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/movie.dart';
import '../../core/providers/watchlist_provider.dart';
import 'add_ratings.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? movieData;

  const MovieDetailScreen({super.key, this.movieData});

  @override
  Widget build(BuildContext context) {
    final movieMap = movieData ?? {
      'id': '-',
      'title': '-',
      'year': 0000,
      'synopsis': '-',
      'directors': '-',
      'poster_url': '-',
      'category': '-',
      'country': '-',
    };

    final movie = Movie.fromJson(movieMap);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WatchlistProvider>(
        builder: (context, watchlistProvider, child) {
          final isWatchlisted = watchlistProvider.isWatchlisted(movie);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(movie.posterUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.posterUrl,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${movie.title} (${movie.year})',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sutradara:\n${movie.directors}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${movie.category}\n${movie.country}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                watchlistProvider.toggleWatchlist(movie);
                              },
                              icon: Icon(
                                isWatchlisted ? Icons.check : Icons.add,
                                size: 18,
                              ),
                              label: Text(
                                isWatchlisted ? 'Watchlisted' : 'Watchlist',
                                style: const TextStyle(fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isWatchlisted
                                    ? Colors.green
                                    : Colors.brown.shade100,
                                foregroundColor: isWatchlisted
                                    ? Colors.white
                                    : Colors.brown.shade900,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddReviewScreen(movieData: movieMap),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.star, size: 18),
                              label: const Text(
                                'Tambah Review',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Sinopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.synopsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}