import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/tmdb_datasource.dart';
import '../../data/datasources/firestore_favorites_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
    return await ref.read(movieRepositoryProvider).getPopularMovies();
  }

  // Pesquisar filmes
  Future<void> search(String query) async {
    state = const AsyncLoading();
    if (query.isEmpty) {
      state = AsyncData(
        await ref.read(movieRepositoryProvider).getPopularMovies(),
      );
    } else {
      state = AsyncData(
        await ref.read(movieRepositoryProvider).searchMovies(query),
      );
    }
  }

  // Favoritar/desfavoritar
  Future<void> toggleFavorite(String userId, Movie movie) async {
    await ref.read(movieRepositoryProvider).toggleFavorite(userId, movie);
  }
}

final movieProvider = AsyncNotifierProvider<MovieNotifier, List<Movie>>(
  MovieNotifier.new,
);