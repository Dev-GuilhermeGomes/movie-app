//É a entidade Movie — basicamente define o que é um filme na app
class Movie {
  final int id; //identificador único
  final String title; //título do filme
  final String overview; //resumo do filme
  final String posterPath; //caminho para o poster do filme
  final double voteAverage; //média de votos do filme
  final String releaseDate; //data de lançamento do filme
  final List<int> genreIds; //lista de identificadores de gêneros do filme
  bool isFavorite; //indica se o filme é favorito ou não (pode ser alterado, por isso não é final)

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    this.isFavorite = false,
  });
}

//O Movie({...}) é o construtor — é o que usas para criar um filme no código
