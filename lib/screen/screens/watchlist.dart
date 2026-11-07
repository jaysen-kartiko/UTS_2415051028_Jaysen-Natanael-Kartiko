import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/watchlist_provider.dart';
import 'movie_detail.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final watchlistMovies = watchlistProvider.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Film', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: watchlistMovies.isEmpty
            ? const Center(
                child: Text(
                  'Watchlist masih kosong',
                  style: TextStyle(color: Colors.brown, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: watchlistMovies.length,
                itemBuilder: (context, index) {
                  final movie = watchlistMovies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          movie.posterUrl,
                          width: 45,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        '${movie.title} (${movie.year})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${movie.category} • ${movie.country}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          watchlistProvider.toggleWatchlist(movie);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movieData: movie.toJson()),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}