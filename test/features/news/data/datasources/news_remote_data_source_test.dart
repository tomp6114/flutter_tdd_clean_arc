// 🔴 RED PHASE — Tests for NewsRemoteDataSource written before implementation.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/models/news_model.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockDio extends Mock implements Dio {}

// ─── Fixtures ────────────────────────────────────────────────────────────────

/// A minimal successful NewsAPI JSON response envelope.
Map<String, dynamic> get tSuccessResponse => {
      'status': 'ok',
      'totalResults': 1,
      'articles': [
        {
          'source': {'id': 'techcrunch', 'name': 'TechCrunch'},
          'author': 'John Doe',
          'title': 'Flutter 4 Released',
          'description': 'The next big Flutter release.',
          'url': 'https://example.com/article',
          'urlToImage': 'https://example.com/image.png',
          'publishedAt': '2025-01-01T00:00:00Z',
          'content': 'Full article content...',
        }
      ],
    };

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late NewsRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = NewsRemoteDataSourceImpl(dio: mockDio);
  });

  group('NewsRemoteDataSource.getTopHeadlines', () {
    const tCountry = 'us';
    const tCategory = 'technology';

    test(
      'should perform a GET request with correct query parameters',
      () async {
        // ARRANGE
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tSuccessResponse,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // ACT
        await dataSource.getTopHeadlines(
          country: tCountry,
          category: tCategory,
        );

        // ASSERT
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            '/top-headlines',
            queryParameters: {
              'country': tCountry,
              'category': tCategory,
            },
          ),
        ).called(1);
      },
    );

    test(
      'should return List<NewsModel> when the response status code is 200',
      () async {
        // ARRANGE
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tSuccessResponse,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // ACT
        final result = await dataSource.getTopHeadlines(
          country: tCountry,
          category: tCategory,
        );

        // ASSERT
        expect(result, isA<List<NewsModel>>());
        expect(result.length, 1);
        expect(result.first.title, 'Flutter 4 Released');
      },
    );

    test(
      'should throw ServerException when Dio throws DioException',
      () async {
        // ARRANGE
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // ACT & ASSERT
        expect(
          () => dataSource.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          ),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw NetworkException when Dio throws a connection timeout',
      () async {
        // ARRANGE
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // ACT & ASSERT
        expect(
          () => dataSource.getTopHeadlines(
            country: tCountry,
            category: tCategory,
          ),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test(
      'should omit category from query params when it is null',
      () async {
        // ARRANGE
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tSuccessResponse,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // ACT
        await dataSource.getTopHeadlines(country: tCountry);

        // ASSERT
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            '/top-headlines',
            queryParameters: {'country': tCountry},
          ),
        ).called(1);
      },
    );
  });
}
