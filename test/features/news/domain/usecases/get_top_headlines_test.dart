// 🔴 RED PHASE — Test written BEFORE implementation.
// This test file proves the necessity of GetTopHeadlines use case.
// Run `flutter test` — tests MUST fail before implementation exists.

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/core/usecase/usecase.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/repositories/news_repository.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/usecases/get_top_headlines.dart';

// ─── Mocks ──────────────────────────────────────────────────────────────────

class MockNewsRepository extends Mock implements NewsRepository {}

// ─── Fixtures ───────────────────────────────────────────────────────────────

final tArticle = NewsArticle(
  id: 'test-id-1',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release.',
  author: 'John Doe',
  urlToImage: 'https://example.com/image.png',
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime(2025, 1, 1),
);

final tArticles = [tArticle];

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late GetTopHeadlines usecase;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    usecase = GetTopHeadlines(mockRepository);
  });

  group('GetTopHeadlines', () {
    const tParams = GetTopHeadlinesParams(country: 'us', category: 'technology');

    test(
      'should implement UseCase<List<NewsArticle>, GetTopHeadlinesParams>',
      () {
        // ARRANGE / ASSERT type compliance at compile time
        expect(usecase, isA<UseCase<List<NewsArticle>, GetTopHeadlinesParams>>());
      },
    );

    test(
      'should return Right<List<NewsArticle>> when the repository call succeeds',
      () async {
        // ARRANGE
        when(
          () => mockRepository.getTopHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
          ),
        ).thenAnswer((_) async => Right(tArticles));

        // ACT
        final result = await usecase(tParams);

        // ASSERT
        expect(result, Right<Failure, List<NewsArticle>>(tArticles));
        verify(
          () => mockRepository.getTopHeadlines(
            country: 'us',
            category: 'technology',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left<ServerFailure> when the repository call fails',
      () async {
        // ARRANGE
        when(
          () => mockRepository.getTopHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure()));

        // ACT
        final result = await usecase(tParams);

        // ASSERT
        expect(result, const Left<Failure, List<NewsArticle>>(ServerFailure()));
        verify(
          () => mockRepository.getTopHeadlines(
            country: 'us',
            category: 'technology',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should pass all params correctly to the repository',
      () async {
        // ARRANGE
        const params = GetTopHeadlinesParams(country: 'gb', category: 'sports');
        when(
          () => mockRepository.getTopHeadlines(
            country: 'gb',
            category: 'sports',
          ),
        ).thenAnswer((_) async => Right(tArticles));

        // ACT
        await usecase(params);

        // ASSERT
        verify(
          () => mockRepository.getTopHeadlines(
            country: 'gb',
            category: 'sports',
          ),
        ).called(1);
      },
    );

    test(
      'should work with null category (no category filter)',
      () async {
        // ARRANGE
        const params = GetTopHeadlinesParams(country: 'us');
        when(
          () => mockRepository.getTopHeadlines(
            country: 'us',
            category: null,
          ),
        ).thenAnswer((_) async => Right(tArticles));

        // ACT
        final result = await usecase(params);

        // ASSERT
        expect(result, Right<Failure, List<NewsArticle>>(tArticles));
      },
    );
  });
}
