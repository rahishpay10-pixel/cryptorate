import '../../domain/entities/crypto_asset.dart';

class CryptoAssetModel {
  const CryptoAssetModel({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.changePercent24Hr,
  });

  factory CryptoAssetModel.fromJson(Map<String, dynamic> json) {
    return CryptoAssetModel(
      id: (json['id'] ?? '').toString(),
      rank: (json['market_cap_rank'] is num)
          ? (json['market_cap_rank'] as num).toInt()
          : int.tryParse((json['market_cap_rank'] ?? '0').toString()) ?? 0,
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      name: (json['name'] ?? '').toString(),
      priceUsd: (json['current_price'] is num)
          ? (json['current_price'] as num).toDouble()
          : double.tryParse((json['current_price'] ?? '0').toString()) ?? 0,
      changePercent24Hr: (json['price_change_percentage_24h'] is num)
          ? (json['price_change_percentage_24h'] as num).toDouble()
          : double.tryParse((json['price_change_percentage_24h'] ?? '0').toString()) ?? 0,
    );
  }

  final String id;
  final int rank;
  final String symbol;
  final String name;
  final double priceUsd;
  final double changePercent24Hr;

  CryptoAsset toEntity() {
    return CryptoAsset(
      id: id,
      rank: rank,
      symbol: symbol,
      name: name,
      priceUsd: priceUsd,
      changePercent24Hr: changePercent24Hr,
    );
  }
}
