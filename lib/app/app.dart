import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../features/market/data/datasources/coincap_market_api.dart';
import '../features/market/data/repositories/market_repository_impl.dart';
import '../features/market/domain/usecases/get_top_assets.dart';
import '../features/market/domain/usecases/watch_prices.dart';
import '../features/market/presentation/cubit/market_cubit.dart';
import '../features/market/presentation/pages/market_page.dart';

class CryptoRateApp extends StatefulWidget {
  const CryptoRateApp({super.key});

  @override
  State<CryptoRateApp> createState() => _CryptoRateAppState();
}

class _CryptoRateAppState extends State<CryptoRateApp> {
  late final Dio _dio;
  late final MarketRepositoryImpl _repository;
  late final MarketCubit _marketCubit;

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        headers: const {'Accept': 'application/json'},
      ),
    );

    final api = CoinGeckoMarketApi(_dio);
    _repository = MarketRepositoryImpl(api: api);
    _marketCubit = MarketCubit(
      getTopAssets: GetTopAssets(_repository),
      watchPrices: WatchPrices(_repository),
    )..init();
  }

  @override
  void dispose() {
    unawaited(_marketCubit.close());
    unawaited(_repository.dispose());
    _dio.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final scale = (width / 390).clamp(0.92, 1.1);
        return BlocProvider.value(
          value: _marketCubit,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CryptoRate',
            themeMode: ThemeMode.dark,
            darkTheme: AppTheme.dark(textScale: scale),
            home: const MarketPage(),
          ),
        );
      },
    );
  }
}
