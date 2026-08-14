import 'package:flutter/material.dart';

class Movie {
  final String id;
  final String title;
  final double rating;
  final String? posterUrl;
  final String overview;
  final String year;
  final String genre;
  final Color color;

  const Movie({
    required this.id,
    required this.title,
    required this.rating,
    this.posterUrl,
    this.overview = 'Sinopsis no disponible.',
    this.year = '2024',
    this.genre = 'Acción',
    this.color = Colors.blueGrey,
  });
}
