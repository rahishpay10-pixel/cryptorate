import 'dart:async';
import 'dart:math';

import '../../domain/entities/crypto_asset.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/coincap_market_api.dart';
import '../datasources/demo_market_data.dart';

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl({required CoinGeckoMarketApi api}) : _api = api;

  final CoinGeckoMarketApi _api;
  final _random = Random();

  bool _demoMode = false;
  Map<String, double> _lastPrices = const {};

  @override
  Future<List<CryptoAsset>> getTopAssets({int limit = 25}) async {
    try {
      final models = await _api.getTopAssets(limit: limit);
      final assets = models.map((m) => m.toEntity()).toList(growable: false);
      _demoMode = false;
      _lastPrices = {for (final a in assets) a.id: a.priceUsd};
      return assets;
    } catch (_) {
      _demoMode = true;
      final assets = DemoMarketData.topAssets();
      _lastPrices = {for (final a in assets) a.id: a.priceUsd};
      return assets;
    }
  }

  @override
  Stream<Map<String, double>> watchPrices({required List<String> assetIds}) {
    if (_demoMode) {
      return _demoPriceStream(assetIds);
    }

    Timer? timer;
    StreamSubscription? demoSub;
    var inFlight = false;

    late final StreamController<Map<String, double>> controller;

    Future<void> tick() async {
      if (inFlight || controller.isClosed) return;
      inFlight = true;
      try {
        final update = await _api.getSimplePrices(assetIds: assetIds);
        if (update.isNotEmpty && !controller.isClosed) {
          _lastPrices = {..._lastPrices, ...update};
          controller.add(update);
        }
      } catch (_) {
        _demoMode = true;
        timer?.cancel();
        demoSub ??= _demoPriceStream(
          assetIds,
        ).listen(controller.add, onError: controller.addError);
      } finally {
        inFlight = false;
      }
    }

    controller = StreamController<Map<String, double>>.broadcast(
      onListen: () {
        tick();
        timer = Timer.periodic(const Duration(seconds: 3), (_) => tick());
      },
      onCancel: () async {
        timer?.cancel();
        await demoSub?.cancel();
        await controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Future<void> dispose() async {}

  Stream<Map<String, double>> _demoPriceStream(List<String> assetIds) {
    final ids = assetIds
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (ids.isEmpty) return const Stream.empty();

    return Stream<Map<String, double>>.periodic(const Duration(seconds: 1), (
      _,
    ) {
      final updates = <String, double>{};
      for (final id in ids) {
        final base = _lastPrices[id] ?? 1.0;
        final pct = (_random.nextDouble() * 0.004) - 0.002;
        final next = (base * (1 + pct)).clamp(0.000001, double.maxFinite);
        updates[id] = next;
        _lastPrices = {..._lastPrices, id: next};
      }
      return updates;
    }).asBroadcastStream();
  }
}
