import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/crypto_asset.dart';
import '../../domain/usecases/get_top_assets.dart';
import '../../domain/usecases/watch_prices.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit({
    required GetTopAssets getTopAssets,
    required WatchPrices watchPrices,
  }) : _getTopAssets = getTopAssets,
       _watchPrices = watchPrices,
       super(MarketState.initial());

  final GetTopAssets _getTopAssets;
  final WatchPrices _watchPrices;

  StreamSubscription? _priceSubscription;

  Future<void> init() async {
    emit(state.copyWith(status: MarketStatus.loading, errorMessage: null));
    try {
      final assets = await _getTopAssets(limit: 25);
      emit(
        state.copyWith(
          status: MarketStatus.success,
          assets: assets,
          errorMessage: null,
        ),
      );

      await _priceSubscription?.cancel();
      final ids = assets.take(20).map((e) => e.id).toList(growable: false);
      _priceSubscription = _watchPrices(
        assetIds: ids,
      ).listen(_applyPriceUpdate);
    } catch (e) {
      emit(
        state.copyWith(
          status: MarketStatus.failure,
          errorMessage: _humanizeError(e),
        ),
      );
    }
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void setSort(MarketSort sort) {
    if (state.sort == sort) {
      emit(state.copyWith(sortDescending: !state.sortDescending));
      return;
    }
    emit(
      state.copyWith(
        sort: sort,
        sortDescending: false,
        manualOrderAssetIds: const [],
      ),
    );
  }

  void setManualOrder(List<String> assetIds) {
    emit(state.copyWith(manualOrderAssetIds: assetIds));
  }

  void clearManualOrder() {
    emit(state.copyWith(manualOrderAssetIds: const []));
  }

  List<CryptoAsset> visibleAssets() {
    final q = state.query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? state.assets
        : state.assets
              .where(
                (a) =>
                    a.name.toLowerCase().contains(q) ||
                    a.symbol.toLowerCase().contains(q) ||
                    a.id.toLowerCase().contains(q),
              )
              .toList(growable: false);

    final manualOrder = state.manualOrderAssetIds;
    if (manualOrder.isNotEmpty) {
      final indexById = <String, int>{
        for (var i = 0; i < manualOrder.length; i++) manualOrder[i]: i,
      };
      final list = [...filtered]
        ..sort((a, b) {
          final ai = indexById[a.id];
          final bi = indexById[b.id];
          if (ai == null && bi == null) return a.rank.compareTo(b.rank);
          if (ai == null) return 1;
          if (bi == null) return -1;
          return ai.compareTo(bi);
        });
      return list;
    }

    int compare(CryptoAsset a, CryptoAsset b) {
      switch (state.sort) {
        case MarketSort.rank:
          return a.rank.compareTo(b.rank);
        case MarketSort.price:
          return a.priceUsd.compareTo(b.priceUsd);
        case MarketSort.change24h:
          return a.changePercent24Hr.compareTo(b.changePercent24Hr);
      }
    }

    final sorted = [...filtered]..sort(compare);
    if (state.sortDescending) {
      return sorted.reversed.toList(growable: false);
    }
    return sorted;
  }

  String _humanizeError(Object error) {
    if (error is DioException) {
      final inner = error.error;
      if (inner is SocketException) {
        return 'Network error: ${inner.message}';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Network error: unable to reach server';
      }
      return error.message ?? error.toString();
    }
    if (error is SocketException) {
      return 'Network error: ${error.message}';
    }
    return error.toString();
  }

  void _applyPriceUpdate(Map<String, double> update) {
    if (update.isEmpty) return;
    var changed = false;
    final next = state.assets
        .map((asset) {
          final price = update[asset.id];
          if (price == null) return asset;
          changed = true;
          return asset.copyWith(priceUsd: price);
        })
        .toList(growable: false);
    if (changed) {
      emit(state.copyWith(assets: next));
    }
  }

  List<CryptoAsset> topTickers({int count = 2}) {
    final list = state.assets;
    if (list.isEmpty) return const [];
    return list.take(count).toList(growable: false);
  }

  @override
  Future<void> close() async {
    await _priceSubscription?.cancel();
    return super.close();
  }
}
