import 'package:equatable/equatable.dart';

import '../../domain/entities/crypto_asset.dart';

enum MarketStatus { initial, loading, success, failure }

enum MarketSort { rank, price, change24h }

class MarketState extends Equatable {
  const MarketState({
    required this.status,
    required this.assets,
    required this.query,
    required this.sort,
    required this.sortDescending,
    required this.manualOrderAssetIds,
    this.errorMessage,
  });

  factory MarketState.initial() {
    return const MarketState(
      status: MarketStatus.initial,
      assets: [],
      query: '',
      sort: MarketSort.rank,
      sortDescending: false,
      manualOrderAssetIds: [],
    );
  }

  final MarketStatus status;
  final List<CryptoAsset> assets;
  final String query;
  final MarketSort sort;
  final bool sortDescending;
  final List<String> manualOrderAssetIds;
  final String? errorMessage;

  MarketState copyWith({
    MarketStatus? status,
    List<CryptoAsset>? assets,
    String? query,
    MarketSort? sort,
    bool? sortDescending,
    List<String>? manualOrderAssetIds,
    String? errorMessage,
  }) {
    return MarketState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      sortDescending: sortDescending ?? this.sortDescending,
      manualOrderAssetIds: manualOrderAssetIds ?? this.manualOrderAssetIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    assets,
    query,
    sort,
    sortDescending,
    manualOrderAssetIds,
    errorMessage,
  ];
}
