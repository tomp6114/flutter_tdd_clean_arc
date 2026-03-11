// 🟢 GREEN PHASE — Dependency Injection (GetIt).

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_tdd_clean_arc/features/news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_tdd_clean_arc/features/news/data/repositories/news_repository_impl.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/repositories/news_repository.dart';
import 'package:flutter_tdd_clean_arc/features/news/domain/usecases/get_top_headlines.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ─── Features - News ───────────────────────────────────────────────────────

  // Bloc
  sl.registerFactory(() => NewsBloc(getTopHeadlines: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dio: sl()),
  );

  // ─── External ──────────────────────────────────────────────────────────────

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org/v2',
      // Provide your API key here (in a real app, use flutter_dotenv)
      queryParameters: {'apiKey': 'YOUR_API_KEY_HERE'},
    ),
  );
  sl.registerLazySingleton(() => dio);
}
