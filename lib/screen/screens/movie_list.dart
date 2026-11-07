import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/providers/watchlist_provider.dart';
import 'movie_detail.dart';
import 'watchlist.dart';
import '../components/movie_filter_chips.dart';
import '../components/movie_grid_card.dart';
import '../components/movie_list_tile.dart';

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
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          movieProvider.errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => movieProvider.fetchMovies(),
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
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => setState(() => searchQuery = value),
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
                      
                      // Menggunakan Component Reusable: MovieFilterChips
                      MovieFilterChips(
                        title: 'Genre:',
                        items: genres,
                        selectedItem: selectedGenre,
                        onSelected: (genre) => setState(() => selectedGenre = genre),
                      ),
                      const SizedBox(height: 8),
                      MovieFilterChips(
                        title: 'Negara:',
                        items: countries,
                        selectedItem: selectedCountry,
                        onSelected: (country) => setState(() => selectedCountry = country),
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
                            onPressed: () => setState(() => isGrid = !isGrid),
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
                                        
                                        // Menggunakan Component Reusable: MovieGridCard
                                        return MovieGridCard(
                                          movie: movie,
                                          isWatchlist: isWatchlist,
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MovieDetailScreen(movieData: movie.toJson()),
                                            ),
                                          ),
                                          onWatchlistToggle: () => watchlistProvider.toggleWatchlist(movie),
                                        );
                                      },
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: filteredMovies.length,
                                      itemBuilder: (context, index) {
                                        final movie = filteredMovies[index];
                                        final isWatchlist = watchlistProvider.isWatchlisted(movie);
                                        
                                        // Menggunakan Component Reusable: MovieListTile
                                        return MovieListTile(
                                          movie: movie,
                                          isWatchlist: isWatchlist,
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MovieDetailScreen(movieData: movie.toJson()),
                                            ),
                                          ),
                                          onWatchlistToggle: () => watchlistProvider.toggleWatchlist(movie),
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