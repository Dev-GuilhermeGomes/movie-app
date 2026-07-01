import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/tmdb_datasource.dart';
import '../datasources/firestore_favorites_datasource.dart';

// Implementação real do contrato definido no Domain
class MovieRepositoryImpl implements MovieRepository {
  final TmdbDataSource _tmdb;
  final FirestoreFavoritesDataSource _firestore;

  MovieRepositoryImpl(this._tmdb, this._firestore);

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final movies = await _tmdb.getPopularMovies(page: page);
    return movies;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final movies = await _tmdb.searchMovies(query);
    return movies;
  }

  @override
  Future<List<String>> getFavoriteIds(String userId) async {
    return await _firestore.getFavoriteIds(userId);
  }

  @override
  Future<void> toggleFavorite(String userId, Movie movie) async {
    await _firestore.toggleFavorite(userId, movie.id, movie.isFavorite);
  }
}
