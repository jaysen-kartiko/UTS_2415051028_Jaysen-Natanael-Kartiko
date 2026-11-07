import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/movie_rating.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/providers/rating_provider.dart';
import 'edit_ratings.dart';

class RatedMovie extends StatefulWidget {
  const RatedMovie({super.key});

  @override
  State<RatedMovie> createState() => _RatedMovieState();
}

class _RatedMovieState extends State<RatedMovie> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RatingProvider>(context, listen: false).fetchRatings();
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final movieProvider = Provider.of<MovieProvider>(context);
    final List<MovieRating> ratedMovies = ratingProvider.ratings;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Review Saya', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ratingProvider.isLoading || movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : ratingProvider.errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.storage, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          ratingProvider.errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            ratingProvider.fetchRatings();
                            movieProvider.fetchMovies();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
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
                            final MovieRating review = ratedMovies[index];
                            
                            final matchingMovies = movieProvider.movies.where((m) => m.id == review.movieId);
                            final movie = matchingMovies.isNotEmpty ? matchingMovies.first : null;

                            final title = movie?.title ?? 'Film Tidak Ditemukan';
                            final year = movie?.year.toString() ?? '';
                            final poster = movie?.posterUrl ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditReviewScreen(rating: review, movie: movie),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: poster.isNotEmpty
                                            ? Image.network(poster, width: 60, height: 90, fit: BoxFit.cover)
                                            : Container(width: 60, height: 90, color: Colors.grey.shade300),
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
                                                    '$title ($year)',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    if (review.favorite)
                                                      const Icon(Icons.favorite, color: Colors.red, size: 18),
                                                    const SizedBox(width: 4),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                                      constraints: const BoxConstraints(),
                                                      padding: EdgeInsets.zero,
                                                      tooltip: 'Hapus Review',
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title: const Text('Hapus Review'),
                                                            content: const Text('Apakah Anda yakin ingin menghapus review ini?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(ctx),
                                                                child: const Text('Batal'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (review.id != null) {
                                                                    ratingProvider.deleteRating(review.id!);
                                                                  }
                                                                  Navigator.pop(ctx);
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    const SnackBar(content: Text('Review berhasil dihapus')),
                                                                  );
                                                                },
                                                                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${review.rating}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Menonton: ${review.watchDate}',
                                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              review.note,
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