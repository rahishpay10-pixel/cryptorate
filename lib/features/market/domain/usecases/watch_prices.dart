import '../repositories/market_repository.dart';

class WatchPrices {
  const WatchPrices(this._repository);

  final MarketRepository _repository;

  Stream<Map<String, double>> call({required List<String> assetIds}) {
    return _repository.watchPrices(assetIds: assetIds);
  }
}

