// 🔴 RED PHASE — Widget tests for NewsPage written BEFORE implementation.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_arc/features/news/domain/entities/news_article.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/bloc/news_bloc.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/pages/news_page.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/widgets/news_card.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

final tArticle = NewsArticle(
  id: 'techcrunch',
  title: 'Flutter 4 Released',
  description: 'The next big Flutter release.',
  author: 'John Doe',
  urlToImage: null,
  url: 'https://example.com/article',
  sourceName: 'TechCrunch',
  publishedAt: DateTime(2025, 1, 1),
);

final tArticles = [tArticle];

Widget makeTestableWidget(Widget body, {required NewsBloc bloc}) {
  return BlocProvider<NewsBloc>.value(
    value: bloc,
    child: MaterialApp(
      home: body,
    ),
  );
}

void main() {
  late MockNewsBloc mockNewsBloc;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
    
    // required for bloc streaming semantics
    when(() => mockNewsBloc.stream).thenAnswer((_) => const Stream<NewsState>.empty());
    when(() => mockNewsBloc.close()).thenAnswer((_) async {});
  });

  group('NewsPage', () {
    testWidgets('should show circular progress indicator when state is NewsLoading', (WidgetTester tester) async {
      when(() => mockNewsBloc.state).thenReturn(const NewsLoading());

      await tester.pumpWidget(makeTestableWidget(const NewsPage(), bloc: mockNewsBloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show widget containing ListView and NewsCard when state is NewsLoaded', (WidgetTester tester) async {
      when(() => mockNewsBloc.state).thenReturn(NewsLoaded(articles: tArticles));

      await tester.pumpWidget(makeTestableWidget(const NewsPage(), bloc: mockNewsBloc));
      
      // Let the listview render
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(NewsCard), findsWidgets);
    });

    testWidgets('should show error message when state is NewsError', (WidgetTester tester) async {
      when(() => mockNewsBloc.state).thenReturn(const NewsError(message: 'Server failure'));

      await tester.pumpWidget(makeTestableWidget(const NewsPage(), bloc: mockNewsBloc));

      expect(find.text('Server failure'), findsOneWidget);
    });

    testWidgets('should show empty/initial state text when state is NewsInitial', (WidgetTester tester) async {
      when(() => mockNewsBloc.state).thenReturn(const NewsInitial());

      await tester.pumpWidget(makeTestableWidget(const NewsPage(), bloc: mockNewsBloc));

      expect(find.text('No news loaded yet.'), findsOneWidget);
    });
  });
}
