// 🔴 RED PHASE — Tests for NewsRepositoryImpl written before implementation.

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/models/news_model.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/repositories/news_repository_impl.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/repositories/news_repository.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

// ─── Fixtures ────────────────────────────────────────────────────────────────

final tNewsModel = NewsModel(
  id: 'techcrunch',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release.',
  author: 'John Doe',
  urlToImage: 'https://example.com/image.png',
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime.parse('2025-01-01T00:00:00Z'),
);

final tArticles = <NewsModel>[tNewsModel];

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('NewsRepositoryImpl', () {
    group('implements NewsRepository contract', () {
      test('should implement NewsRepository', () {
        expect(repository, isA<NewsRepository>());
      });
    });

    group('getTopHeadlines', () {
      const tCountry = 'us';
      const tCategory = 'technology';

      test(
        'should return Right<List<NewsArticle>> when data source call succeeds',
        () async {
          // ARRANGE
          when(
            () => mockDataSource.getTopHeadlines(
              country: any(named: 'country'),
              category: any(named: 'category'),
            ),
          ).thenAnswer((_) async => tArticles);

          // ACT
          final result = await repository.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          );

          // ASSERT
          expect(result, isA<Right<Failure, List<NewsArticle>>>());
          result.fold(
            (l) => fail('Expected Right but got Left'),
            (articles) {
              expect(articles.length, 1);
              expect(articles.first.title, 'Flutter 4 Released');
            },
          );
          verify(
            () => mockDataSource.getTopHeadlines(
              country: tCountry,
              category: tCategory,
            ),
          ).called(1);
        },
      );

      test(
        'should return Left<ServerFailure> when data source throws ServerException',
        () async {
          // ARRANGE
          when(
            () => mockDataSource.getTopHeadlines(
              country: any(named: 'country'),
              category: any(named: 'category'),
            ),
          ).thenThrow(const ServerException(message: 'Server error'));

          // ACT
          final result = await repository.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          );

          // ASSERT
          expect(result, isA<Left<Failure, List<NewsArticle>>>());
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (r) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'should return Left<NetworkFailure> when data source throws NetworkException',
        () async {
          // ARRANGE
          when(
            () => mockDataSource.getTopHeadlines(
              country: any(named: 'country'),
              category: any(named: 'category'),
            ),
          ).thenThrow(const NetworkException(message: 'No internet'));

          // ACT
          final result = await repository.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          );

          // ASSERT
          expect(result, isA<Left<Failure, List<NewsArticle>>>());
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (r) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'should correctly map ServerException message into ServerFailure',
        () async {
          // ARRANGE
          when(
            () => mockDataSource.getTopHeadlines(
              country: any(named: 'country'),
              category: any(named: 'category'),
            ),
          ).thenThrow(const ServerException(message: 'API key invalid'));

          // ACT
          final result = await repository.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          );

          // ASSERT
          result.fold(
            (failure) => expect(failure.message, 'API key invalid'),
            (r) => fail('Expected Left'),
          );
        },
      );
    });
  });
}
