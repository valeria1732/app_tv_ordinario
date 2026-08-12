import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onRefresh;

  const HomeAppBar({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: AppTheme.background.withAlpha(180),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            title: FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('❤️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        'Mis Películas Favoritas',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 24),
                    color: AppTheme.textSecondary,
                    onPressed: onRefresh,
                    tooltip: 'Recargar',
                    splashRadius: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
