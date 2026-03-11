// 🟢 GREEN PHASE — NewsRepositoryImpl bridges data and domain layers.

import 'package:fpdart/fpdart.dart';

import 'package:flutter_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/repositories/news_repository.dart';

/// Concrete implementation of [NewsRepository] (defined in domain layer).
///
/// Responsibilities:
///  1. Call the data source.
///  2. Catch typed exceptions and map them to domain [Failure]s.
///  3. Return an [Either] so the domain/presentation layer never sees exceptions.
final class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  const NewsRepositoryImpl({required NewsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<NewsArticle>>> getTopHeadlines({
    required String country,
    String? category,
  }) async {
    try {
      final models = await _remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
      );
      // NewsModel IS-A NewsArticle — no explicit mapping needed.
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
