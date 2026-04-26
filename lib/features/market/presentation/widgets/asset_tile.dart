import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/crypto_asset.dart';

class AssetTile extends StatelessWidget {
  const AssetTile({super.key, required this.asset});

  final CryptoAsset asset;

  @override
  Widget build(BuildContext context) {
    final change = asset.changePercent24Hr;
    final isUp = change >= 0;
    final changeColor = isUp ? AppTheme.positive(context) : AppTheme.negative(context);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(
                asset.rank.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.muted(context),
                    ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.symbol, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(
                    asset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.muted(context),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.usd(asset.priceUsd),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        letterSpacing: 0.2,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  Formatters.percent(change),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: changeColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

