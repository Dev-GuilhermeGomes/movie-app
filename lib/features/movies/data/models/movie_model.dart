import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genreIds,
    super.isFavorite,
  });

  // Converte o JSON da API do TMDB para um objeto MovieModel
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] as String? ?? '',
      genreIds: List<int>.from(json['genre_ids'] as List),
    );
  }
}

//Isto pega no JSON que vem do TMDB e transforma num objeto Movie que a app vai usar.