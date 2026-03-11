import 'package:go_router/go_router.dart';

import 'package:flutter_tdd_clean_arc/features/news/presentation/pages/news_page.dart';

/// Application router using GoRouter for declarative routing.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const NewsPage(),
    ),
  ],
);
