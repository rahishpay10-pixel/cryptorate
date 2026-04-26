Here’s your **clean, fully polished README.md** rewritten in proper professional English, keeping your original structure and intent intact 👇

````md id="5k8d2p"
# 📈 CryptoRate (Flutter)

An interview-ready Flutter sample application built using Clean Architecture, featuring a responsive UI, dark theme, REST API integration (Dio), and simulated live price updates.

---

## ✨ Highlights

- Clean Architecture (data / domain / presentation) with a feature-first structure  
- Dark theme with custom typography  
- Responsive layout (mobile + tablet/desktop friendly)  
- Crypto market list with:
  - Search functionality  
  - Watchlist tabs  
  - Pull-to-refresh  
- Reorderable watchlist screen (drag & drop support)  
- Data source: CoinGecko REST API  

### 🔄 Live Updates Approach

- Polling-based price stream (updates every few seconds)  
- Automatic fallback to demo data if network/DNS fails (ideal for interviews)  

---

## 🌐 API Used

### Market List

```http
GET https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false
````

### Live Prices

Since CoinGecko does not provide direct WebSocket support, the app uses polling:

```http
GET https://api.coingecko.com/api/v3/simple/price?ids=...&vs_currencies=usd&include_24hr_change=true
```

---

## 🏗 Project Structure (Clean Architecture)

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

---

## ⚡ How Live Updates Work

* CoinGecko’s market data is REST-only and does not provide WebSocket endpoints.
* The app periodically calls the `simple/price` endpoint to simulate real-time updates.
* If a network or DNS issue occurs (e.g., emulator internet problems or blocked DNS), the app automatically switches to demo data.

This ensures the UI always remains functional during demos or interviews.

---

## 🚀 Getting Started

### ✅ Requirements

* Flutter (stable)
* Dart SDK compatible with:

  ```
  sdk: ^3.10.3
  ```

---

### ▶️ Run Locally

```bash
flutter pub get
flutter run
```

---

### 🔍 Quality Checks

```bash
flutter analyze
flutter test
```

---

## 📝 Notes

* Follows Clean Architecture with clear separation:
  **Data Sources → Repository → Use Cases → Cubit → UI**

* Easy to extend or modify:

  * If you have a real WebSocket or socket.io backend, you can replace polling in
    `MarketRepository.watchPrices()` with a streaming implementation.

---

## 📄 License

This project is built for interview and demonstration purposes.

```