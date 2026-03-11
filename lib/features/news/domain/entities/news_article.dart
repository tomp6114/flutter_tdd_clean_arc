import 'package:equatable/equatable.dart';

/// Pure domain entity representing a single news article.
///
/// Has ZERO dependencies on Flutter, data, or presentation layers.
/// Equatable provides value equality — useful in bloc tests.
base class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? author;
  final String? urlToImage;
  final String url;
  final String sourceName;
  final DateTime publishedAt;

  const NewsArticle({
    required this.id,
    required this.title,
    this.description,
    this.author,
    this.urlToImage,
    required this.url,
    required this.sourceName,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        author,
        urlToImage,
        url,
        sourceName,
        publishedAt,
      ];
}
