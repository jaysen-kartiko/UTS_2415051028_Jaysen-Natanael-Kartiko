import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final List watchlistMovies = [
    {
      'title': 'Oppenheimer',
      'year': 2023,
      'genre': 'Drama',
      'country': 'USA',
      'poster': 'https://picsum.photos/seed/oppenheimer/300/450',
    },
    {
      'title': 'Dune: Part Two',
      'year': 2024,
      'genre': 'Sci-Fi',
      'country': 'USA',
      'poster': 'https://picsum.photos/seed/dune2/300/450',
    },
    {
      'title': 'Interstellar',
      'year': 2014,
      'genre': 'Sci-Fi',
      'country': 'USA',
      'poster': 'https://picsum.photos/seed/interstellar/300/450',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                          movie['poster'],
                          width: 45,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        '${movie['title']} (${movie['year']})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${movie['genre']} • ${movie['country']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            watchlistMovies.removeAt(index);
                          });
                        },
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
      ),
    );
  }
}