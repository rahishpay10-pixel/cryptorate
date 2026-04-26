# CryptoRate (Flutter)

Interview-ready Flutter sample app with Clean Architecture, responsive UI, dark theme, REST (Dio) + “live” price updates.

## Highlights

- Clean Architecture (data / domain / presentation) with feature-first structure
- Dark theme + custom typography
- Responsive layout (mobile + tablet/desktop friendly)
- Crypto market list with search, watchlist tabs, pull-to-refresh
- Reorder watchlist screen (drag & drop)
- Data source: CoinGecko REST API
- Live updates approach:
  - Polling-based price stream (updates every few seconds)
  - Automatic fallback to demo data if network/DNS fails (good for interviews)

## Demo Video

GitHub README me video embed ka best/professional approach:

### Option A (Recommended): Upload to GitHub Releases / YouTube and link

- Video ko GitHub Release me upload karo (Releases → New release → attach file) OR YouTube pe unlisted upload karo.
- Phir README me link add karo:

```md
## Demo

▶️ Watch demo: https://your-link-here
```

### Option B: Keep video inside repo and link it

- Repo me folder bana ke video rakho (example): `assets/demo.mp4`
- README me link add karo:

```md
## Demo

Demo video: [assets/demo.mp4](assets/demo.mp4)
```

Note: GitHub README me MP4 usually inline player ki tarah render nahi hota (link ke form me best rehta hai). Agar inline preview chahiye, to MP4 ko GIF me convert karke `assets/demo.gif` embed karo.

Current repo demo video:

```md
## Demo

Demo video: [assets/Screen Recording 2026-04-26 at 12.07.53 PM.mov](assets/Screen%20Recording%202026-04-26%20at%2012.07.53%E2%80%AFPM.mov)
```

## API Used

- Market list:
  - `GET https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false`
- Live prices:
  - CoinGecko REST endpoint se WebSocket direct possible nahi hota, isliye app polling use karta hai:
  - `GET https://api.coingecko.com/api/v3/simple/price?ids=...&vs_currencies=usd&include_24hr_change=true`

## Project Structure (Clean Architecture)

```txt
lib/
  app/
    app.dart
  core/
    theme/
      app_theme.dart
    utils/
      formatters.dart
  features/
    market/
      data/
        datasources/
          coincap_market_api.dart        // CoinGeckoMarketApi (REST)
          demo_market_data.dart          // Fallback data
        models/
          crypto_asset_model.dart
        repositories/
          market_repository_impl.dart    // Polling stream + fallback
      domain/
        entities/
          crypto_asset.dart
        repositories/
          market_repository.dart
        usecases/
          get_top_assets.dart
          watch_prices.dart
      presentation/
        cubit/
          market_cubit.dart
          market_state.dart
        pages/
          market_page.dart
          reorder_watchlist_page.dart
        widgets/
          asset_tile.dart
          market_top_ticker.dart
```

## How Live Updates Work

- CoinGecko ka market endpoint REST-only hai, WebSocket endpoint provide nahi karta.
- Isliye app `simple/price` endpoint ko interval par hit karke “live-like” stream banata hai.
- Agar network/DNS issue ho (emulator internet issue, blocked DNS, etc.), app demo stream pe fallback kar leta hai so UI always working rahe.

## Getting Started

### Requirements

- Flutter (stable)
- Dart SDK compatible with `sdk: ^3.10.3`

### Run locally

```bash
flutter pub get
flutter run
```

### Quality checks

```bash
flutter analyze
flutter test
```

## Notes (Interview)

- Clean Architecture + separation of concerns: data sources → repository → use cases → Cubit → UI
- Easy to swap data source:
  - Agar aapke paas real WebSocket/socket.io endpoint ho, to `MarketRepository.watchPrices()` ko polling se socket stream me replace karna straightforward hai.

## License

This project is built for interview/demo purposes.
