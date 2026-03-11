// 🟢 GREEN PHASE — Minimal implementation to make tests pass.

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_tdd_clean_arc/core/usecase/usecase.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/repositories/news_repository.dart';

/// Parameters for the [GetTopHeadlines] use case.
class GetTopHeadlinesParams extends Equatable {
  final String country;
  final String? category;

  const GetTopHeadlinesParams({
    required this.country,
    this.category,
  });

  @override
  List<Object?> get props => [country, category];
}

/// Use case: Fetch top headlines from the news repository.
///
/// Implements [UseCase] so it can be injected and swapped easily.
/// Contains ZERO business logic beyond orchestration — keeps Domain pure.
class GetTopHeadlines
    implements UseCase<List<NewsArticle>, GetTopHeadlinesParams> {
  final NewsRepository _repository;

  const GetTopHeadlines(this._repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call(
    GetTopHeadlinesParams params,
  ) async {
    return _repository.getTopHeadlines(
      country: params.country,
      category: params.category,
    );
  }
}
