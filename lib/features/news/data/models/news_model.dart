// 🟢 GREEN PHASE — NewsModel implementation.

import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';

/// Data model that extends [NewsArticle] and handles JSON serialisation.
///
/// Follows the Open/Closed principle — extending entity with JSON logic
/// rather than polluting the pure domain entity.
final class NewsModel extends NewsArticle {
  const NewsModel({
    required super.id,
    required super.title,
    super.description,
    super.author,
    super.urlToImage,
    required super.url,
    required super.sourceName,
    required super.publishedAt,
  });

  /// Creates a [NewsModel] from a NewsAPI article JSON object.
  ///
  /// Falls back to `sourceName` as the `id` when the API returns a null
  /// source id (common for smaller publications).
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>;
    final sourceId = source['id'] as String?;
    final sourceName = source['name'] as String? ?? '';

    return NewsModel(
      id: sourceId ?? sourceName,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      author: json['author'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String? ?? '',
      sourceName: sourceName,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  /// Serialises this model to a flat JSON map (used for local caching).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'urlToImage': urlToImage,
      'url': url,
      'sourceName': sourceName,
      'publishedAt': publishedAt.toUtc().toIso8601String(),
    };
  }
}
