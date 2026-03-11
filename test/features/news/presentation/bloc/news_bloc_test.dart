// 🔴 RED PHASE — bloc_test written BEFORE the Bloc implementation.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/usecases/get_top_headlines.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/bloc/news_bloc.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockGetTopHeadlines extends Mock implements GetTopHeadlines {}

// ─── Fixtures ────────────────────────────────────────────────────────────────

final tArticle = NewsArticle(
  id: 'techcrunch',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release.',
  author: 'John Doe',
  urlToImage: 'https://example.com/image.png',
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime(2025, 1, 1),
);

final tArticles = [tArticle];

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late NewsBloc newsBloc;
  late MockGetTopHeadlines mockGetTopHeadlines;

  // Register fallback for GetTopHeadlinesParams (needed by mocktail any())
  setUpAll(() {
    registerFallbackValue(
      const GetTopHeadlinesParams(country: 'us'),
    );
  });

  setUp(() {
    mockGetTopHeadlines = MockGetTopHeadlines();
    newsBloc = NewsBloc(getTopHeadlines: mockGetTopHeadlines);
  });

  tearDown(() => newsBloc.close());

  group('NewsBloc', () {
    test('initial state should be NewsInitial', () {
      expect(newsBloc.state, isA<NewsInitial>());
    });

    group('on NewsArticlesFetched', () {
      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsLoaded] when use case returns articles',
        build: () {
          when(() => mockGetTopHeadlines(any()))
              .thenAnswer((_) async => Right(tArticles));
          return newsBloc;
        },
        act: (bloc) => bloc.add(
          const NewsArticlesFetched(country: 'us', category: 'technology'),
        ),
        expect: () => [
          isA<NewsLoading>(),
          isA<NewsLoaded>(),
        ],
        verify: (_) {
          verify(
            () => mockGetTopHeadlines(
              const GetTopHeadlinesParams(
                country: 'us',
                category: 'technology',
              ),
            ),
          ).called(1);
        },
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsLoaded] with correct articles list',
        build: () {
          when(() => mockGetTopHeadlines(any()))
              .thenAnswer((_) async => Right(tArticles));
          return newsBloc;
        },
        act: (bloc) => bloc.add(
          const NewsArticlesFetched(country: 'us'),
        ),
        expect: () => [
          isA<NewsLoading>(),
          NewsLoaded(articles: tArticles),
        ],
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsError] with server message when ServerFailure',
        build: () {
          when(() => mockGetTopHeadlines(any())).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server down')),
          );
          return newsBloc;
        },
        act: (bloc) => bloc.add(
          const NewsArticlesFetched(country: 'us'),
        ),
        expect: () => [
          isA<NewsLoading>(),
          const NewsError(message: 'Server down'),
        ],
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsError] with network message when NetworkFailure',
        build: () {
          when(() => mockGetTopHeadlines(any())).thenAnswer(
            (_) async =>
                const Left(NetworkFailure(message: 'No internet connection.')),
          );
          return newsBloc;
        },
        act: (bloc) => bloc.add(
          const NewsArticlesFetched(country: 'us'),
        ),
        expect: () => [
          isA<NewsLoading>(),
          const NewsError(message: 'No internet connection.'),
        ],
      );

      blocTest<NewsBloc, NewsState>(
        'passes null category to use case when category is omitted',
        build: () {
          when(() => mockGetTopHeadlines(any()))
              .thenAnswer((_) async => Right(tArticles));
          return newsBloc;
        },
        act: (bloc) => bloc.add(
          const NewsArticlesFetched(country: 'gb'),
        ),
        verify: (_) {
          verify(
            () => mockGetTopHeadlines(
              const GetTopHeadlinesParams(country: 'gb'),
            ),
          ).called(1);
        },
      );

      blocTest<NewsBloc, NewsState>(
        'does not emit duplicate loading when called twice rapidly',
        build: () {
          when(() => mockGetTopHeadlines(any()))
              .thenAnswer((_) async => Right(tArticles));
          return newsBloc;
        },
        act: (bloc) {
          bloc.add(const NewsArticlesFetched(country: 'us'));
          bloc.add(const NewsArticlesFetched(country: 'us'));
        },
        expect: () => [
          isA<NewsLoading>(),
          isA<NewsLoaded>(),
          isA<NewsLoading>(),
          isA<NewsLoaded>(),
        ],
      );
    });
  });
}
