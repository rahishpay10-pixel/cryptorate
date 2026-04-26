import '../../domain/entities/crypto_asset.dart';

class DemoMarketData {
  static List<CryptoAsset> topAssets() {
    return const [
      CryptoAsset(
        id: 'bitcoin',
        rank: 1,
        symbol: 'BTC',
        name: 'Bitcoin',
        priceUsd: 65000,
        changePercent24Hr: 1.20,
      ),
      CryptoAsset(
        id: 'ethereum',
        rank: 2,
        symbol: 'ETH',
        name: 'Ethereum',
        priceUsd: 3500,
        changePercent24Hr: -0.40,
      ),
      CryptoAsset(
        id: 'tether',
        rank: 3,
        symbol: 'USDT',
        name: 'Tether',
        priceUsd: 1.00,
        changePercent24Hr: 0.01,
      ),
      CryptoAsset(
        id: 'bnb',
        rank: 4,
        symbol: 'BNB',
        name: 'BNB',
        priceUsd: 580,
        changePercent24Hr: 0.30,
      ),
      CryptoAsset(
        id: 'solana',
        rank: 5,
        symbol: 'SOL',
        name: 'Solana',
        priceUsd: 145,
        changePercent24Hr: 2.10,
      ),
      CryptoAsset(
        id: 'xrp',
        rank: 6,
        symbol: 'XRP',
        name: 'XRP',
        priceUsd: 0.55,
        changePercent24Hr: -1.10,
      ),
      CryptoAsset(
        id: 'cardano',
        rank: 7,
        symbol: 'ADA',
        name: 'Cardano',
        priceUsd: 0.42,
        changePercent24Hr: 0.80,
      ),
      CryptoAsset(
        id: 'dogecoin',
        rank: 8,
        symbol: 'DOGE',
        name: 'Dogecoin',
        priceUsd: 0.15,
        changePercent24Hr: -0.70,
      ),
      CryptoAsset(
        id: 'polkadot',
        rank: 9,
        symbol: 'DOT',
        name: 'Polkadot',
        priceUsd: 6.80,
        changePercent24Hr: 1.50,
      ),
      CryptoAsset(
        id: 'tron',
        rank: 10,
        symbol: 'TRX',
        name: 'TRON',
        priceUsd: 0.12,
        changePercent24Hr: 0.40,
      ),
    ];
  }
}

