import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/tmdb_datasource.dart';
import '../../data/datasources/firestore_favorites_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provider do Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {'api_key': '800327baf57d2bed3c9db7f5007dfdd6'},
  ));
});

// Provider do repositório
final movieRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final tmdb = TmdbDataSource(dio);
  final firestore = FirestoreFavoritesDataSource(FirebaseFirestore.instance);
  return MovieRepositoryImpl(tmdb, firestore);
});

// Estado da lista de filmes
class MovieNotifier extends AsyncNotifier<List<Movie>> {
  @override
  Future<List<Movie>> build() async {
    return await _loadMoviesWithFavorites(
      await ref.read(movieRepositoryProvider).getPopularMovies(),
    );
  }

  // Marca os filmes que já estão nos favoritos do utilizador
  Future<List<Movie>> _loadMoviesWithFavorites(List<Movie> movies) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return movies;

    final favoriteIds = await ref.read(movieRepositoryProvider).getFavoriteIds(userId);

    for (final movie in movies) {
      movie.isFavorite = favoriteIds.contains(movie.id.toString());
    }
    return movies;
  }

  // Pesquisar filmes
  Future<void> search(String query) async {
    state = const AsyncLoading();
    final repo = ref.read(movieRepositoryProvider);
    final movies = query.isEmpty
        ? await repo.getPopularMovies()
        : await repo.searchMovies(query);

    state = AsyncData(await _loadMoviesWithFavorites(movies));
  }

  // Favoritar/desfavoritar
  Future<void> toggleFavorite(Movie movie) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      // Atualiza no Firestore
      await ref.read(movieRepositoryProvider).toggleFavorite(userId, movie);
      // Atualiza o estado local para refletir na UI imediatamente
      movie.isFavorite = !movie.isFavorite;
      final currentMovies = state.value ?? [];
      state = AsyncData([...currentMovies]);
    } catch (e) {
      // Se falhar, o estado local não muda — fica sincronizado com o Firestore
    }
  }
}

final movieProvider = AsyncNotifierProvider<MovieNotifier, List<Movie>>(
  MovieNotifier.new,
);