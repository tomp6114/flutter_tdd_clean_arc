// 🟢 GREEN PHASE — NewsPage implementation.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_tdd_clean_arc/features/news/presentation/bloc/news_bloc.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/widgets/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch articles when the page first loads
    context.read<NewsBloc>().add(const NewsArticlesFetched(country: 'us'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        centerTitle: true,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(const NewsArticlesFetched(country: 'us'));
              },
              child: ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  return NewsCard(article: state.articles[index]);
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewsBloc>().add(const NewsArticlesFetched(country: 'us'));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          // Default / Initial state
          return const Center(child: Text('No news loaded yet.'));
        },
      ),
    );
  }
}
