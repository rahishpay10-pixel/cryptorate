import 'package:dio/dio.dart';

import '../models/crypto_asset_model.dart';

class CoinGeckoMarketApi {
  CoinGeckoMarketApi(this._dio);

  final Dio _dio;

  Future<List<CryptoAssetModel>> getTopAssets({int limit = 25}) async {
    final response = await _dio.get<List<dynamic>>(
      'https://api.coingecko.com/api/v3/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': limit,
        'page': 1,
        'sparkline': false,
      },
      options: Options(
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    final rawList = response.data;
    if (rawList == null) return const [];

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(CryptoAssetModel.fromJson)
        .toList(growable: false);
  }

  Future<Map<String, double>> getSimplePrices({
    required List<String> assetIds,
  }) async {
    final ids = assetIds
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (ids.isEmpty) return const {};

    final response = await _dio.get<Map<String, dynamic>>(
      'https://api.coingecko.com/api/v3/simple/price',
      queryParameters: {
        'ids': ids.join(','),
        'vs_currencies': 'usd',
        'include_24hr_change': true,
      },
      options: Options(
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    final data = response.data;
    if (data == null) return const {};
    final out = <String, double>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        final usd = value['usd'];
        final price = usd is num
            ? usd.toDouble()
            : double.tryParse(usd?.toString() ?? '');
        if (price != null) out[key] = price;
      }
    }
    return out;
  }
}
