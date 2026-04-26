import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cryptorate/features/market/domain/entities/crypto_asset.dart';
import 'package:cryptorate/features/market/domain/repositories/market_repository.dart';
import 'package:cryptorate/features/market/domain/usecases/get_top_assets.dart';
import 'package:cryptorate/features/market/domain/usecases/watch_prices.dart';
import 'package:cryptorate/features/market/presentation/cubit/market_cubit.dart';
import 'package:cryptorate/features/market/presentation/pages/market_page.dart';

void main() {
  testWidgets('Market screen renders watchlist tabs and assets', (WidgetTester tester) async {
    final repo = _FakeMarketRepository();
    final cubit = MarketCubit(
      getTopAssets: GetTopAssets(repo),
      watchPrices: WatchPrices(repo),
    );
    await cubit.init();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const MarketPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Watchlist 1'), findsOneWidget);
    expect(find.text('Watchlist 5'), findsOneWidget);
    expect(find.text('Watchlist 6'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
  });
}

class _FakeMarketRepository implements MarketRepository {
  @override
  Future<void> dispose() async {}

  @override
  Future<List<CryptoAsset>> getTopAssets({int limit = 25}) async {
    return const [
      CryptoAsset(
        id: 'bitcoin',
        rank: 1,
        symbol: 'BTC',
        name: 'Bitcoin',
        priceUsd: 65000,
        changePercent24Hr: 1.2,
      ),
      CryptoAsset(
        id: 'ethereum',
        rank: 2,
        symbol: 'ETH',
        name: 'Ethereum',
        priceUsd: 3500,
        changePercent24Hr: -0.4,
      ),
    ];
  }

  @override
  Stream<Map<String, double>> watchPrices({required List<String> assetIds}) {
    return const Stream.empty();
  }
}
