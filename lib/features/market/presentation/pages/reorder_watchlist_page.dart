import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/crypto_asset.dart';

class ReorderWatchlistPage extends StatefulWidget {
  const ReorderWatchlistPage({
    super.key,
    required this.assets,
    required this.initialOrderAssetIds,
  });

  final List<CryptoAsset> assets;
  final List<String> initialOrderAssetIds;

  @override
  State<ReorderWatchlistPage> createState() => _ReorderWatchlistPageState();
}

class _ReorderWatchlistPageState extends State<ReorderWatchlistPage> {
  late List<CryptoAsset> _items;

  @override
  void initState() {
    super.initState();
    _items = _applyInitialOrder(
      assets: widget.assets,
      orderAssetIds: widget.initialOrderAssetIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Watchlist'),
        actions: [
          TextButton(
            onPressed: _items.isEmpty ? null : () => Navigator.pop(context, const <String>[]),
            child: const Text('Reset'),
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'No assets',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.muted(context)),
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              itemCount: _items.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final asset = _items[index];
                final changeColor = asset.changePercent24Hr >= 0
                    ? AppTheme.positive(context)
                    : AppTheme.negative(context);

                return Card(
                  key: ValueKey(asset.id),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Row(
                      children: [
                        Text(asset.symbol, style: theme.textTheme.titleMedium),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            asset.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.muted(context)),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Text(
                            Formatters.usd(asset.priceUsd),
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Formatters.percent(asset.changePercent24Hr),
                            style: theme.textTheme.bodySmall?.copyWith(color: changeColor),
                          ),
                        ],
                      ),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(Icons.drag_handle, color: AppTheme.muted(context)),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: FilledButton(
            onPressed: _items.isEmpty
                ? null
                : () => Navigator.pop(
                      context,
                      _items.map((e) => e.id).toList(growable: false),
                    ),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }

  List<CryptoAsset> _applyInitialOrder({
    required List<CryptoAsset> assets,
    required List<String> orderAssetIds,
  }) {
    if (orderAssetIds.isEmpty) return [...assets]..sort((a, b) => a.rank.compareTo(b.rank));
    final indexById = <String, int>{
      for (var i = 0; i < orderAssetIds.length; i++) orderAssetIds[i]: i,
    };
    final list = [...assets]
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
}

