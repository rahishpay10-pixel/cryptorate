import '../entities/crypto_asset.dart';

abstract class MarketRepository {
  Future<List<CryptoAsset>> getTopAssets({int limit});

  Stream<Map<String, double>> watchPrices({required List<String> assetIds});

  Future<void> dispose();
}

