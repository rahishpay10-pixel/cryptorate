import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';

class MarketTopTicker extends StatelessWidget {
  const MarketTopTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      buildWhen: (prev, next) =>
          prev.assets != next.assets || prev.status != next.status,
      builder: (context, state) {
        final items = context.read<MarketCubit>().topTickers(count: 2);
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TickerCell(
                  label: items.isNotEmpty ? items[0].symbol : 'BTC',
                  value: items.isNotEmpty
                      ? Formatters.usd(items[0].priceUsd)
                      : '—',
                  delta: items.isNotEmpty
                      ? Formatters.percent(items[0].changePercent24Hr)
                      : '—',
                  deltaUp: items.isNotEmpty
                      ? items[0].changePercent24Hr >= 0
                      : true,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
              ),
              Expanded(
                child: _TickerCell(
                  label: items.length > 1 ? items[1].symbol : 'ETH',
                  value: items.length > 1
                      ? Formatters.usd(items[1].priceUsd)
                      : '—',
                  delta: items.length > 1
                      ? Formatters.percent(items[1].changePercent24Hr)
                      : '—',
                  deltaUp: items.length > 1
                      ? items[1].changePercent24Hr >= 0
                      : true,
                  showChevron: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TickerCell extends StatelessWidget {
  const _TickerCell({
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaUp,
    this.showChevron = false,
  });

  final String label;
  final String value;
  final String delta;
  final bool deltaUp;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final deltaColor = deltaUp
        ? AppTheme.positive(context)
        : AppTheme.negative(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(value, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(width: 10),
                    Text(
                      delta,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: deltaColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: AppTheme.muted(context)),
          ],
        ],
      ),
    );
  }
}
