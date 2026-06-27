import '../entities/movie.dart';

// Contrato do repositório de filmes
// Define O QUÊ fazer, não O COMO
abstract interface class MovieRepository {
  // Vai buscar a lista de filmes populares (página por página)
  Future<List<Movie>> getPopularMovies({int page = 1});

  // Pesquisa filmes por nome
  Future<List<Movie>> searchMovies(String query);

  // Vai buscar os IDs dos filmes favoritos de um utilizador
  Future<List<String>> getFavoriteIds(String userId);

  // Adiciona ou remove um filme dos favoritos
  Future<void> toggleFavorite(String userId, Movie movie);
}
