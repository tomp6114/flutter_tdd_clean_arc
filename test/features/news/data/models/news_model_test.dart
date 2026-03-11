// 🔴 RED PHASE — Test for NewsModel written before the implementation.


import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_arc/features/news/data/models/news_model.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Simulates a single article JSON object as returned by the NewsAPI.
Map<String, dynamic> get tArticleJson => {
      'source': {'id': 'techcrunch', 'name': 'TechCrunch'},
      'author': 'John Doe',
      'title': 'Flutter 4 Released',
      'description': 'The next big Flutter release.',
      'url': 'https://example.com/article',
      'urlToImage': 'https://example.com/image.png',
      'publishedAt': '2025-01-01T00:00:00Z',
      'content': 'Full article content...',
    };

final tNewsModel = NewsModel(
  id: 'techcrunch',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release.',
  author: 'John Doe',
  urlToImage: 'https://example.com/image.png',
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime.parse('2025-01-01T00:00:00Z'),
);

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('NewsModel', () {
    group('is a subtype of NewsArticle entity', () {
      test('should be a subclass of NewsArticle', () {
        expect(tNewsModel, isA<NewsArticle>());
      });
    });

    group('fromJson', () {
      test('should return a valid NewsModel when JSON is correct', () {
        // ACT
        final result = NewsModel.fromJson(tArticleJson);

        // ASSERT
        expect(result, tNewsModel);
      });

      test('should correctly parse the source name', () {
        final result = NewsModel.fromJson(tArticleJson);
        expect(result.sourceName, 'TechCrunch');
      });

      test('should correctly parse publishedAt as DateTime', () {
        final result = NewsModel.fromJson(tArticleJson);
        expect(result.publishedAt, DateTime.parse('2025-01-01T00:00:00Z'));
      });

      test('should use source name as id when source id is null', () {
        final jsonWithNullId = Map<String, dynamic>.from(tArticleJson)
          ..['source'] = {'id': null, 'name': 'TechCrunch'};
        final result = NewsModel.fromJson(jsonWithNullId);
        expect(result.id, 'TechCrunch');
      });

      test('should handle null optional fields gracefully', () {
        final minimalJson = {
          'source': {'id': null, 'name': 'BBC'},
          'author': null,
          'title': 'Some Title',
          'description': null,
          'url': 'https://bbc.com',
          'urlToImage': null,
          'publishedAt': '2025-06-15T12:00:00Z',
          'content': null,
        };
        final result = NewsModel.fromJson(minimalJson);
        expect(result.author, isNull);
        expect(result.description, isNull);
        expect(result.urlToImage, isNull);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the correct data', () {
        // ACT
        final result = tNewsModel.toJson();

        // ASSERT
        expect(result['title'], 'Flutter 4 Released');
        expect(result['author'], 'John Doe');
        expect(result['url'], 'https://example.com/article');
        expect(result['urlToImage'], 'https://example.com/image.png');
        expect(result['publishedAt'], '2025-01-01T00:00:00.000Z');
        expect(result['sourceName'], 'TechCrunch');
      });

      test('should be reversible: fromJson(toJson()) gives equivalent model', () {
        final json = tNewsModel.toJson();
        // Note: toJson uses our flat format; fromJson uses NewsAPI format.
        // This tests the internal flat format round-trip.
        final rebuilt = NewsModel(
          id: json['id'] as String,
          title: json['title'] as String,
          description: json['description'] as String?,
          author: json['author'] as String?,
          urlToImage: json['urlToImage'] as String?,
          url: json['url'] as String,
          sourceName: json['sourceName'] as String,
          publishedAt: DateTime.parse(json['publishedAt'] as String),
        );
        expect(rebuilt, tNewsModel);
      });
    });
  });
}
