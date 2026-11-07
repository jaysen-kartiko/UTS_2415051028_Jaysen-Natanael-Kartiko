import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/movie_list.dart';
import 'screens/rated_movie.dart';

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const MovieList(),
    const RatedMovie(),
  ];

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.movie), label: 'Film'),
        NavigationDestination(icon: Icon(Icons.star), label: 'Review'),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.movie), label: Text('Film')),
        NavigationRailDestination(icon: Icon(Icons.star), label: Text('Review')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieTracker'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
            return Scaffold(
              body: _pages[currentIndex],
              bottomNavigationBar: buildNavigationBar(),
            );

         
        },
      ),
    );
  }
}