import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/providers/watchlist_provider.dart';
import 'screen/navigation_wrapper.dart';
import 'core/providers/movie_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()..fetchMovies()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NavigationApp(),
      ),
    );
  }
}