import 'package:flutter/material.dart';
import '../../core/models/movie.dart'; 
class MovieListTile extends StatelessWidget {
  final Movie movie;
  final bool isWatchlist;
  final VoidCallback onTap;
  final VoidCallback onWatchlistToggle;

  const MovieListTile({
    super.key,
    required this.movie,
    required this.isWatchlist,
    required this.onTap,
    required this.onWatchlistToggle,
  });

  @override
  Widget build(BuildContext context) {
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
        subtitle: Text('${movie.category}\n${movie.country}'),
        trailing: IconButton(
          icon: Icon(
            isWatchlist ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.brown,
          ),
          onPressed: onWatchlistToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}