import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_list_bloc.dart';
import '../bloc/product_list_event.dart';
import '../bloc/product_list_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/error_body.dart';
import '../widgets/product_card.dart';
import '../widgets/header.dart';
import '../../domain/entities/product.dart';

/// Storefront-style product list (reference UI).
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      context.read<ProductListBloc>().add(
        ProductListSearchChanged(_searchController.text),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductListBloc>().add(const ProductListRequested());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<ProductListBloc>().add(const ProductListLoadMoreRequested());
    }
  }

  String _categoryHint(List<Product> products) {
    if (products.isEmpty) return 'sản phẩm';
    final c = products.first.category;
    if (c == 'product') return 'sản phẩm';
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          final products = state.visibleProducts;
          final showLoadMoreError = state.status == ProductListStatus.error &&
              state.products.isNotEmpty;
          final showLoadingMore =
              state.status == ProductListStatus.loadingMore;
          final extra = (showLoadMoreError ? 1 : 0) + (showLoadingMore ? 1 : 0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StorefrontHeader(
                searchController: _searchController,
                categoryHint: _categoryHint(state.products),
                cartCount: 2,
                selectedTab: state.sortTab,
                onTabSelected: (t) => context.read<ProductListBloc>().add(
                  ProductListSortTabChanged(t),
                ),
                priceAscending: state.priceAscending,
                onPriceTabTap: () => context.read<ProductListBloc>().add(
                  const ProductListPriceSortToggled(),
                ),
                inStockOnly: state.inStockOnly,
                onInStockChanged: (v) => context.read<ProductListBloc>().add(
                  ProductListInStockOnlyChanged(v),
                ),
              ),
              Expanded(
                child: switch (state.status) {
                  ProductListStatus.initial ||
                  ProductListStatus.loading when state.products.isEmpty =>
                    const Center(child: CircularProgressIndicator()),
                  ProductListStatus.error when state.products.isEmpty =>
                    ErrorBody(
                      message: state.errorMessage ?? 'Unknown error',
                      onRetry: () => context
                          .read<ProductListBloc>()
                          .add(const ProductListRequested()),
                    ),
                  _ => RefreshIndicator(
                      color: AppColors.accentBlue,
                      onRefresh: () async {
                        final bloc = context.read<ProductListBloc>();
                        bloc.add(const ProductListRefreshRequested());
                        await bloc.stream.firstWhere(
                          (s) =>
                              s.status == ProductListStatus.ready ||
                              s.status == ProductListStatus.error,
                        );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: products.length + extra,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ProductCard(
                                product: product,
                                showEditStyle:
                                    index == 0 && product.isInStock,
                                onTap: () =>
                                   {},
                              ),
                            );
                          }
                          final tail = index - products.length;
                          if (showLoadMoreError && tail == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Material(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  title: Text(
                                    state.errorMessage ?? 'Load failed',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: TextButton(
                                    onPressed: () => context
                                        .read<ProductListBloc>()
                                        .add(
                                          const ProductListLoadMoreRequested(),
                                        ),
                                    child: const Text('Thử lại'),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (showLoadingMore &&
                              tail == (showLoadMoreError ? 1 : 0)) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                },
              ),
            ],
          );
        },
      ),
    );
  }

}

