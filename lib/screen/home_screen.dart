import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/movie.dart';
import '../services/movie_service.dart';
import '../app_theme.dart';
import '../widgets/home_app_bar.dart';
import 'sliver_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  late List<Movie> _movies;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    setState(() {
      _movies = _movieService.getFavoriteMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          HomeAppBar(onRefresh: _loadMovies),
          MovieSliverGrid(
            movies: _movies,
            onMovieSelect: (movie) {
              context.push('/detail', extra: movie);
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          )
        ],
      ),
    );
  }
}
