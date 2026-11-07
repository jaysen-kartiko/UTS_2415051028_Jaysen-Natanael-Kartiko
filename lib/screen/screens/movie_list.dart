import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/providers/watchlist_provider.dart';
import 'movie_detail.dart';
import 'watchlist.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String searchQuery = '';
  String selectedGenre = 'Semua';
  String selectedCountry = 'Semua';
  bool isGrid = true;

  final List<String> genres = ['Semua', 'Sci-Fi', 'Drama', 'Action', 'Animation'];
  final List<String> countries = ['Semua', 'USA', 'UK', 'South Korea'];

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final movies = movieProvider.movies;

    final filteredMovies = movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenre == 'Semua' || movie.category.contains(selectedGenre);
      final matchesCountry = selectedCountry == 'Semua' || movie.country.contains(selectedCountry);
      return matchesSearch && matchesGenre && matchesCountry;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Daftar Film', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.brown),
            tooltip: 'Watchlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WatchlistScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : movieProvider.errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    'Terjadi Kesalahan: ${movieProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari nama film...',
                          prefixIcon: const Icon(Icons.search, color: Colors.brown),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.brown, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.brown.shade50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text('Genre: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                            ...genres.map((genre) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(genre),
                                    selected: selectedGenre == genre,
                                    selectedColor: Colors.brown,
                                    labelStyle: TextStyle(
                                      color: selectedGenre == genre ? Colors.white : Colors.brown,
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedGenre = genre;
                                      });
                                    },
                                  ),
                                )),
                            const SizedBox(width: 16),
                            const Text('Negara: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                            ...countries.map((country) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(country),
                                    selected: selectedCountry == country,
                                    selectedColor: Colors.brown,
                                    labelStyle: TextStyle(
                                      color: selectedCountry == country ? Colors.white : Colors.brown,
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedCountry = country;
                                      });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ditemukan ${filteredMovies.length} Film',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                          ),
                          IconButton(
                            icon: Icon(isGrid ? Icons.list : Icons.grid_view, color: Colors.brown),
                            onPressed: () {
                              setState(() {
                                isGrid = !isGrid;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredMovies.isEmpty
                            ? const Center(
                                child: Text(
                                  'Film tidak ditemukan',
                                  style: TextStyle(color: Colors.brown, fontSize: 16),
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  if (isGrid) {
                                    int crossAxisCount = 2;
                                    if (constraints.maxWidth > 900) {
                                      crossAxisCount = 4;
                                    } else if (constraints.maxWidth > 600) {
                                      crossAxisCount = 3;
                                    }
                                    return GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 0.58,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: filteredMovies.length,
                                      itemBuilder: (context, index) {
                                        final movie = filteredMovies[index];
                                        final isWatchlist = watchlistProvider.isWatchlisted(movie);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MovieDetailScreen(movieData: movie.toJson()),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Image.network(
                                                    movie.posterUrl,
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
                                                        '${movie.title} (${movie.year})',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        '${movie.category} • ${movie.country}',
                                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 28,
                                                        child: ElevatedButton.icon(
                                                          onPressed: () {
                                                            watchlistProvider.toggleWatchlist(movie);
                                                          },
                                                          icon: Icon(isWatchlist ? Icons.check : Icons.add, size: 14),
                                                          label: Text(isWatchlist ? 'Watchlisted' : 'Watchlist', style: const TextStyle(fontSize: 10)),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: isWatchlist ? Colors.green : Colors.brown,
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
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: filteredMovies.length,
                                      itemBuilder: (context, index) {
                                        final movie = filteredMovies[index];
                                        final isWatchlist = watchlistProvider.isWatchlisted(movie);
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
                                              icon: Icon(
                                                isWatchlist ? Icons.bookmark : Icons.bookmark_border,
                                                color: Colors.brown,
                                              ),
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
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}