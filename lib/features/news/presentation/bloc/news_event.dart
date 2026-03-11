// 🟢 GREEN PHASE — NewsEvent definitions.

part of 'news_bloc.dart';

/// Base sealed class for all News events.
/// Sealed ensures exhaustive handling in the Bloc's `on<>` handlers.
sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched when the UI wants to load/refresh top headlines.
final class NewsArticlesFetched extends NewsEvent {
  final String country;
  final String? category;

  const NewsArticlesFetched({
    required this.country,
    this.category,
  });

  @override
  List<Object?> get props => [country, category];
}
