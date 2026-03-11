import 'package:fpdart/fpdart.dart';
import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';

/// Abstract contract for the News feature repository.
///
/// Lives in the Domain layer — the Data layer MUST implement this interface.
/// The Domain layer never knows about the concrete implementation (DIP).
abstract interface class NewsRepository {
  /// Fetches top headlines for the given [country] and [category].
  ///
  /// Returns [Right] with a list of [NewsArticle] on success,
  /// or [Left] with a [Failure] on error.
  Future<Either<Failure, List<NewsArticle>>> getTopHeadlines({
    required String country,
    String? category,
  });
}
