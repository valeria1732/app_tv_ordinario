import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../model/movie.dart';
import '../widgets/movie_card.dart';

class MovieSliverGrid extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieSelect;

  const MovieSliverGrid({
    super.key,
    required this.movies,
    required this.onMovieSelect,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Refined breakpoints for ultra-wide, desktop, tablet, and mobile
    int crossAxisCount;
    double aspectRatio;
    
    if (screenWidth < 500) {
      crossAxisCount = 2;
      aspectRatio = 0.65;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
      aspectRatio = 0.68;
    } else if (screenWidth < 1200) {
      crossAxisCount = 4;
      aspectRatio = 0.70;
    } else {
      crossAxisCount = 5;
      aspectRatio = 0.70;
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = movies[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: index * 50),
              child: MovieCard(
                movie: movie,
                autofocus: index == 0,
                onSelect: () => onMovieSelect(movie),
              ),
            );
          },
          childCount: movies.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: aspectRatio,
        ),
      ),
    );
  }
}
