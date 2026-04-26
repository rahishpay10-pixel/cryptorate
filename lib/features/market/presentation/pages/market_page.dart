import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';
import 'reorder_watchlist_page.dart';
import '../widgets/asset_tile.dart';
import '../widgets/market_top_ticker.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final _searchController = TextEditingController();
  int _navIndex = 0;

  Future<void> _openReorder() async {
    final cubit = context.read<MarketCubit>();
    final assets = cubit.state.assets;
    if (assets.isEmpty) return;
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder: (context) => ReorderWatchlistPage(
          assets: assets,
          initialOrderAssetIds: cubit.state.manualOrderAssetIds,
        ),
      ),
    );
    if (!mounted || result == null) return;
    if (result.isEmpty) {
      cubit.clearManualOrder();
    } else {
      cubit.setManualOrder(result);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontal = width >= 480 ? 20.0 : 16.0;
        final maxContent = width >= 900 ? 720.0 : double.infinity;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContent),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          12,
                          horizontal,
                          10,
                        ),
                        child: const MarketTopTicker(),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          0,
                          horizontal,
                          12,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: context.read<MarketCubit>().setQuery,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search for coins',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: 'Watchlist 1'),
                          Tab(text: 'Watchlist 5'),
                          Tab(text: 'Watchlist 6'),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          10,
                          horizontal,
                          8,
                        ),
                        child: Row(
                          children: [
                            _SortButton(onTap: _openReorder),
                            const Spacer(),
                            IconButton(
                              onPressed: () =>
                                  context.read<MarketCubit>().init(),
                              icon: Icon(
                                Icons.refresh,
                                color: AppTheme.muted(context),
                              ),
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _AssetsList(horizontalPadding: horizontal),
                            _AssetsList(horizontalPadding: horizontal),
                            _AssetsList(horizontalPadding: horizontal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: 'Watchlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flash_on_outlined),
                  label: 'GTT+',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart_outline),
                  label: 'Portfolio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Funds',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AssetsList extends StatelessWidget {
  const _AssetsList({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state.status == MarketStatus.loading ||
            state.status == MarketStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MarketStatus.failure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.muted(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: context.read<MarketCubit>().init,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final assets = context.read<MarketCubit>().visibleAssets();
        if (assets.isEmpty) {
          return Center(
            child: Text(
              'No results',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted(context)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: context.read<MarketCubit>().init,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              6,
              horizontalPadding,
              18,
            ),
            itemCount: assets.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, index) {
              return AssetTile(asset: assets[index]);
            },
          ),
        );
      },
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface2(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, size: 18, color: AppTheme.muted(context)),
            const SizedBox(width: 8),
            Text('Sort by', style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
