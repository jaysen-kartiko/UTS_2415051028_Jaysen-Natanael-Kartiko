import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/watchlist_provider.dart';
import 'screen/navigation_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NavigationApp(),
      ),
    );
  }
}