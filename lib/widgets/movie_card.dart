import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/movie.dart';
import '../app_theme.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final bool autofocus;
  final VoidCallback onSelect;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onSelect,
    this.autofocus = false,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCirc),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onFocusEnter() {
    setState(() => _isFocused = true);
    _scaleController.forward();
  }

  void _onFocusExit() {
    setState(() => _isFocused = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final hasPoster = widget.movie.posterUrl != null && widget.movie.posterUrl!.isNotEmpty;

    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (focused) => focused ? _onFocusEnter() : _onFocusExit(),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
             event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.gameButtonA)) {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) => _onFocusEnter(),
        onExit: (_) => _onFocusExit(),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onSelect,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused ? AppTheme.primaryLight : Colors.transparent,
                  width: _isFocused ? 3 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withAlpha(120),
                          blurRadius: 24,
                          spreadRadius: 4,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image or Placeholder
                    if (hasPoster)
                      Image.asset(
                        widget.movie.posterUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      )
                    else
                      _buildPlaceholder(),

                    // Bottom Gradient for Text Legibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 80,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Rating Badge (Top Left)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(160),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24, width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppTheme.accentRating,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.movie.rating % 1 == 0
                                  ? widget.movie.rating.toInt().toString()
                                  : widget.movie.rating.toString(),
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Movie Title (Bottom Center)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        widget.movie.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.surface,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: AppTheme.primaryLight,
          size: 48,
        ),
      ),
    );
  }
}
