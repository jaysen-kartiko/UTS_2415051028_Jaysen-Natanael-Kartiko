import 'package:flutter/material.dart';
import 'edit_ratings.dart';

class RatedMovie extends StatelessWidget {
  const RatedMovie({super.key});

  @override
  Widget build(BuildContext context) {
    final List ratedMovies = [
      {
        'title': 'Oppenheimer',
        'year': 2023,
        'rating': 4.5,
        'note': 'Visual dan musik latarnya luar biasa menegangkan!',
        'watch_date': DateTime(2023, 10, 15),
        'favorite': true,
        'poster': 'https://picsum.photos/seed/oppenheimer/300/450',
      },
      {
        'title': 'Interstellar',
        'year': 2014,
        'rating': 5.0,
        'note': 'Film sci-fi terbaik sepanjang masa dengan konsep fisika yang keren.',
        'watch_date': DateTime(2024, 1, 10),
        'favorite': true,
        'poster': 'https://picsum.photos/seed/interstellar/300/450',
      },
      {
        'title': 'Parasite',
        'year': 2019,
        'rating': 4.0,
        'note': 'Alur cerita penuh plot twist yang tidak tertebak.',
        'watch_date': DateTime(2024, 2, 2),
        'favorite': false,
        'poster': 'https://picsum.photos/seed/parasite/300/450',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Review Saya', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ratedMovies.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada film yang di-review',
                  style: TextStyle(color: Colors.brown, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: ratedMovies.length,
                itemBuilder: (context, index) {
                  final review = ratedMovies[index];
                  final watchDate = review['watch_date'] as DateTime;
                  final formattedDate = '${watchDate.day}-${watchDate.month}-${watchDate.year}';
                  
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditReviewScreen(reviewData: review),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                review['poster'],
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${review['title']} (${review['year']})',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (review['favorite'])
                                        const Icon(Icons.favorite, color: Colors.red, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${review['rating']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Menonton: $formattedDate',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    review['note'],
                                    style: const TextStyle(fontSize: 13, color: Colors.brown),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}