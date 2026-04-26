import 'package:equatable/equatable.dart';

class CryptoAsset extends Equatable {
  const CryptoAsset({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.changePercent24Hr,
  });

  final String id;
  final int rank;
  final String symbol;
  final String name;
  final double priceUsd;
  final double changePercent24Hr;

  CryptoAsset copyWith({
    int? rank,
    double? priceUsd,
    double? changePercent24Hr,
  }) {
    return CryptoAsset(
      id: id,
      rank: rank ?? this.rank,
      symbol: symbol,
      name: name,
      priceUsd: priceUsd ?? this.priceUsd,
      changePercent24Hr: changePercent24Hr ?? this.changePercent24Hr,
    );
  }

  @override
  List<Object?> get props => [id, rank, symbol, name, priceUsd, changePercent24Hr];
}

