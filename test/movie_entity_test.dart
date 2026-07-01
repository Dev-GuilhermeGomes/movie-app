import'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';

void main() {
  test('deve criar um Movie com isFavorite false por defeito', () {
    final movie = Movie(
      id: 1,
      title: 'Fight Club',
      overview: 'Um homem insone...',
      posterPath: '/abc.jpg',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      genreIds: [18],
    );

    expect(movie.isFavorite, false);
  });

  test('deve criar um Movie com isFavorite true quando especificado', () {
    final movie = Movie(
      id: 1,
      title: 'Fight Club',
      overview: 'Um homem insone...',
      posterPath: '/abc.jpg',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      genreIds: [18],
      isFavorite: true,
    );

    expect(movie.isFavorite, true);
  });

  test('deve guardar corretamente todos os campos do Movie', () {
    final movie = Movie(
      id: 550,
      title: 'Fight Club',
      overview: 'Um homem insone...',
      posterPath: '/poster.jpg',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      genreIds: [18, 53],
    );

    expect(movie.id, 550);
    expect(movie.title, 'Fight Club');
    expect(movie.voteAverage, 8.4);
    expect(movie.genreIds, [18, 53]);
  });

  test('deve permitir alterar isFavorite depois de criado', () {
    final movie = Movie(
      id: 1,
      title: 'Fight Club',
      overview: 'Um homem insone...',
      posterPath: '/abc.jpg',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      genreIds: [18],
    );

    movie.isFavorite = true;

    expect(movie.isFavorite, true);
  });
}