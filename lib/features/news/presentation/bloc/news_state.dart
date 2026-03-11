// 🟢 GREEN PHASE — NewsState definitions.

part of 'news_bloc.dart';

/// Base sealed class for all News states.
sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

/// The bloc's initial state before any event is dispatched.
final class NewsInitial extends NewsState {
  const NewsInitial();
}

/// Emitted while the use case is in flight.
final class NewsLoading extends NewsState {
  const NewsLoading();
}

/// Emitted when articles are fetched successfully.
final class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;

  const NewsLoaded({required this.articles});

  @override
  List<Object?> get props => [articles];
}

/// Emitted when the use case returns a [Failure].
final class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}
