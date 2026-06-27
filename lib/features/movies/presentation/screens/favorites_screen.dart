import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_provider.dart';
import '../../domain/entities/movie.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(movieProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A22),
        title: const Text('Favoritos',
          style: TextStyle(color: Color(0xFFE8C547), fontWeight: FontWeight.bold)),
      ),
      body: moviesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE8C547))),
        error: (e, _) => Center(
          child: Text('Erro: $e', style: const TextStyle(color: Colors.red))),
        data: (movies) {
          final favorites = movies.where((m) => m.isFavorite).toList();

          if (favorites.isEmpty) {
            return const Center(
              child: Text('Ainda não tens favoritos',
                style: TextStyle(color: Colors.grey, fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) => _FavoriteItem(movie: favorites[index]),
          );
        },
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final Movie movie;
  const _FavoriteItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: movie.posterPath.isNotEmpty
              ? Image.network(
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  width: 60, height: 90, fit: BoxFit.cover)
              : const SizedBox(width: 60, height: 90,
                  child: Icon(Icons.movie, color: Colors.grey)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                  style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star, color: Color(0xFFE8C547), size: 14),
                  const SizedBox(width: 4),
                  Text(movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(color: Color(0xFFE8C547), fontSize: 13)),
                ]),
                const SizedBox(height: 4),
                Text(movie.releaseDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.favorite, color: Color(0xFFE8C547)),
        ],
      ),
    );
  }
}