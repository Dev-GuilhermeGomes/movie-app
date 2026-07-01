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

  final testMovie = Movie(
    id: 1,
    title: 'Fight Club',
    overview: 'Um homem insone...',
    posterPath: '/abc.jpg',
    voteAverage: 8.4,
    releaseDate: '1999-10-15',
    genreIds: [18],
  );

  test('deve favoritar um filme com sucesso', () async {
    when(() => mockRepository.toggleFavorite('user123', testMovie))
        .thenAnswer((_) async {});

    await mockRepository.toggleFavorite('user123', testMovie);

    verify(() => mockRepository.toggleFavorite('user123', testMovie)).called(1);
  });

  test('deve ir buscar lista de IDs favoritos', () async {
    when(() => mockRepository.getFavoriteIds('user123'))
        .thenAnswer((_) async => ['1', '2', '3']);

    final result = await mockRepository.getFavoriteIds('user123');

    expect(result, ['1', '2', '3']);
    expect(result.length, 3);
  });

  test('deve lançar exceção ao favoritar sem userId válido', () async {
    when(() => mockRepository.toggleFavorite('', testMovie))
        .thenThrow(Exception('userId inválido'));

    expect(() => mockRepository.toggleFavorite('', testMovie), throwsException);
  });
}