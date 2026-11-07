import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final List above2023Movies = [
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
        'title': 'Interstellar 2',
        'year': 2025,
        'genre': 'Sci-Fi',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/interstellar2/300/450',
      },
      {
        'title': 'Spider-Man Beyond',
        'year': 2024,
        'genre': 'Action',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/spidey/300/450',
      },
      {
        'title': 'Avatar 3',
        'year': 2025,
        'genre': 'Sci-Fi',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/avatar3/300/450',
      },
    ];

    final List below2023Movies = [
      {
        'title': 'Inception',
        'year': 2010,
        'genre': 'Sci-Fi',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/inception/300/450',
      },
      {
        'title': 'The Dark Knight',
        'year': 2008,
        'genre': 'Action',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/darkknight/300/450',
      },
      {
        'title': 'Interstellar',
        'year': 2014,
        'genre': 'Sci-Fi',
        'country': 'USA',
        'poster': 'https://picsum.photos/seed/interstellar/300/450',
      },
      {
        'title': 'Parasite',
        'year': 2019,
        'genre': 'Drama',
        'country': 'South Korea',
        'poster': 'https://picsum.photos/seed/parasite/300/450',
      },
      {
        'title': 'Gladiator',
        'year': 2000,
        'genre': 'Action',
        'country': 'UK',
        'poster': 'https://picsum.photos/seed/gladiator/300/450',
      },
    ];

    Widget buildHorizontalMovieList(List movies) {
      return SizedBox(
        height: 290,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        movie['poster'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${movie['title']} (${movie['year']})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${movie['genre']} • ${movie['country']}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 14),
                              label: const Text('Watchlist', style: TextStyle(fontSize: 10)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Jaysen Natanael Kartiko',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '@jaysennatanael',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Movie enthusiast & Letterboxd fan.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Film Di Atas 2023',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),
            buildHorizontalMovieList(above2023Movies),
            const SizedBox(height: 24),
            const Text(
              'Film Di Bawah Tahun 2023',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),
            buildHorizontalMovieList(below2023Movies),
          ],
        ),
      ),
    );
  }
}