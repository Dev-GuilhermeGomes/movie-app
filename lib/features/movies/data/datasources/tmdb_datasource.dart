import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class TmdbDataSource {
  final Dio _dio;

  TmdbDataSource(this._dio);

  // Vai buscar filmes populares à API do TMDB
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final response = await _dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  // Pesquisa filmes por nome
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );

    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }
}

//Faz os pedidos HTTP à API do TMDB.