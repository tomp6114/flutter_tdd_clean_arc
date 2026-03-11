import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_tdd_clean_arc/core/di/service_locator.dart';
import 'package:flutter_tdd_clean_arc/core/routing/app_router.dart';
import 'package:flutter_tdd_clean_arc/features/news/presentation/bloc/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await initServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Bloc at the root so it's accessible anywhere
    return BlocProvider(
      create: (_) => sl<NewsBloc>(),
      child: MaterialApp.router(
        title: 'TDD Clean Architecture News',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

