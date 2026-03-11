// 🟢 GREEN PHASE — NewsRemoteDataSource interface + Dio implementation.

import 'package:dio/dio.dart';

import 'package:flutter_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/models/news_model.dart';

/// Contract for the news remote data source.
///
/// Defined in the data layer so that the repository depends on this
/// abstraction (not on Dio directly), making the datasource mockable in tests.
abstract interface class NewsRemoteDataSource {
  /// Fetches top headlines from the NewsAPI.
  ///
  /// Throws [ServerException] on non-2xx HTTP responses.
  /// Throws [NetworkException] on connectivity errors.
  Future<List<NewsModel>> getTopHeadlines({
    required String country,
    String? category,
  });
}

/// Concrete implementation that talks to the NewsAPI via Dio.
final class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  const NewsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<NewsModel>> getTopHeadlines({
    required String country,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'country': country,
        'category': category,
      }..removeWhere((_, v) => v == null);

      final response = await _dio.get<Map<String, dynamic>>(
        '/top-headlines',
        queryParameters: queryParams,
      );

      final data = response.data!;
      final articles = data['articles'] as List<dynamic>;

      return articles
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Connectivity / timeout errors → NetworkException
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      // All other Dio errors (4xx, 5xx) → ServerException
      final message = e.response?.statusMessage ?? 'A server error occurred.';
      throw ServerException(message: message);
    }
  }
}
