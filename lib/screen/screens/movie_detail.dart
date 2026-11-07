import 'package:flutter/material.dart';
import '../screens/add_ratings.dart';

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const MovieDetailScreen({super.key, this.movieData});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isWatchlisted = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movieData ?? {
      'id': '1',
      'title': 'Oppenheimer',
      'year': 2023,
      'synopsis':
          'Kisah ilmuwan Amerika, J. Robert Oppenheimer, dan perannya dalam pengembangan bom atom selama Perang Dunia II pada proyek Manhattan yang mengubah jalannya sejarah dunia.',
      'directors': 'Christopher Nolan',
      'poster_url': 'https://picsum.photos/seed/oppenheimer/300/450',
      'category': 'Drama, History, Biography',
      'country': 'USA',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                      image: NetworkImage(movie['poster_url']),
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
                          movie['poster_url'],
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
                              '${movie['title']} (${movie['year']})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sutradara:\n${movie['directors']}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${movie['category']}\n${movie['country']}',
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
                            setState(() {
                              isWatchlisted = !isWatchlisted;
                            });
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
                                builder: (context) => AddReviewScreen(movieData: movie),
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
                    movie['synopsis'],
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
      ),
    );
  }
}