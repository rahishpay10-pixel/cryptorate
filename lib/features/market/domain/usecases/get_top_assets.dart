import '../entities/crypto_asset.dart';
import '../repositories/market_repository.dart';

class GetTopAssets {
  const GetTopAssets(this._repository);

  final MarketRepository _repository;

  Future<List<CryptoAsset>> call({int limit = 25}) {
    return _repository.getTopAssets(limit: limit);
  }
}

