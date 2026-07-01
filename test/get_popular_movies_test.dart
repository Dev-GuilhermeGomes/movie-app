import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
  });

  final testMovies = [
    Movie(
      id: 1,
      title: 'Fight Club',
      overview: 'Um homem insone...',
      posterPath: '/abc.jpg',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      genreIds: [18],
    ),
    Movie(
      id: 2,
      title: 'Inception',
      overview: 'Um ladrão de sonhos...',
      posterPath: '/def.jpg',
      voteAverage: 8.8,
      releaseDate: '2010-07-16',
      genreIds: [28, 878],
    ),
  ];

  test('deve devolver lista de filmes populares com sucesso', () async {
    when(() => mockRepository.getPopularMovies())
        .thenAnswer((_) async => testMovies);

    final result = await mockRepository.getPopularMovies();

    expect(result, testMovies);
    expect(result.length, 2);
    verify(() => mockRepository.getPopularMovies()).called(1);
  });

  test('deve devolver lista vazia quando não há filmes', () async {
    when(() => mockRepository.getPopularMovies())
        .thenAnswer((_) async => []);

    final result = await mockRepository.getPopularMovies();

    expect(result, isEmpty);
  });

  test('deve lançar exceção quando a API falha', () async {
    when(() => mockRepository.getPopularMovies())
        .thenThrow(Exception('Erro de rede'));

    expect(() => mockRepository.getPopularMovies(), throwsException);
  });
}