import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(movieProvider);
    final currentMovie = moviesAsync.maybeWhen(
      data: (movies) {
        final found = movies.where((m) => m.id == movie.id);
        return found.isNotEmpty ? found.first : movie;
      },
      orElse: () => movie,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF1A1A22),
            expandedHeight: 400,
            pinned: true,
            iconTheme: const IconThemeData(color: Color(0xFFE8C547)),
            flexibleSpace: FlexibleSpaceBar(
              background: currentMovie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${currentMovie.posterPath}',
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: const Color(0xFF1A1A22),
                      child: const Icon(Icons.movie, color: Colors.grey, size: 80),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentMovie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFE8C547), size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${currentMovie.voteAverage.toStringAsFixed(1)}/10',
                        style: const TextStyle(
                          color: Color(0xFFE8C547),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        currentMovie.releaseDate,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      color: Color(0xFFE8C547),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentMovie.overview.isNotEmpty
                        ? currentMovie.overview
                        : 'Sem sinopse disponível.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(movieProvider.notifier).toggleFavorite(currentMovie);
                      },
                      icon: Icon(
                        currentMovie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.black,
                      ),
                      label: Text(
                        currentMovie.isFavorite
                            ? 'Remover dos Favoritos'
                            : 'Adicionar aos Favoritos',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8C547),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}