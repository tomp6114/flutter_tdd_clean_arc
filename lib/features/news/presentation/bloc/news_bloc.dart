// 🟢 GREEN PHASE — NewsBloc implementation.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/usecases/get_top_headlines.dart';

part 'news_event.dart';
part 'news_state.dart';

/// Presentation-layer Bloc for the News feature.
///
/// Responsibilities:
///  1. Map incoming [NewsEvent]s to outgoing [NewsState]s.
///  2. Delegate ALL business logic to the injected [GetTopHeadlines] use case.
///  3. Never import Dio, http, or any data-layer class.
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines _getTopHeadlines;

  NewsBloc({required GetTopHeadlines getTopHeadlines})
      : _getTopHeadlines = getTopHeadlines,
        super(const NewsInitial()) {
    on<NewsArticlesFetched>(_onNewsArticlesFetched);
  }

  Future<void> _onNewsArticlesFetched(
    NewsArticlesFetched event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading());

    final result = await _getTopHeadlines(
      GetTopHeadlinesParams(
        country: event.country,
        category: event.category,
      ),
    );

    // Exhaustive switch on the sealed Failure hierarchy.
    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }
}
