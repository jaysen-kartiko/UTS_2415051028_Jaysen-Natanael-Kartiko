import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/providers/movie_provider.dart';
import 'core/providers/rating_provider.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/watchlist_provider.dart';
import 'screen/navigation_wrapper.dart';
import 'screen/screens/home_page.dart';
import 'screen/screens/login_page.dart';
import '../../core/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '',
  );
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  debugPrint('Auth event: ${data.event}');

  if (data.event == AuthChangeEvent.signedOut) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
});


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
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..fetchUserProfile(1)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: NavigationApp(),
         home: AuthService.instance.isLoggedIn ? const HomePage() : const LoginPage(), 
      ),
    );
  }
}