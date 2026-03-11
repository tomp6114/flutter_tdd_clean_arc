// 🔴 RED PHASE — Widget tests for NewsCard written BEFORE implementation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/widgets/news_card.dart';

// ─── Fixtures ────────────────────────────────────────────────────────────────

final tArticle = NewsArticle(
  id: 'techcrunch',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release is here with awesome features.',
  author: 'John Doe',
  urlToImage: null,
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime(2025, 1, 1),
);

// ─── Helpers ─────────────────────────────────────────────────────────────────

Widget makeTestableWidget(Widget body) {
  return MaterialApp(
    home: Scaffold(
      body: body,
    ),
  );
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  group('NewsCard', () {
    testWidgets('should display article title, source, and description', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(makeTestableWidget(NewsCard(article: tArticle)));

      // Assert
      expect(find.text('Flutter 4 Released'), findsOneWidget);
      expect(find.text('TechCrunch'), findsOneWidget);
      expect(find.text('The next big Flutter release is here with awesome features.'), findsOneWidget);
    });

    testWidgets('should display a placeholder when image URL is null', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(makeTestableWidget(NewsCard(article: tArticle)));

      // Assert
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });
  });
}
