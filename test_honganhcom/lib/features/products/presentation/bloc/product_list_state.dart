import '../../domain/entities/product.dart';

enum ProductListStatus { initial, loading, ready, loadingMore, error }
enum StorefrontSortTab { all, newest, price }

/// Immutable UI state emitted by [ProductListBloc].
final class ProductListState {
  const ProductListState({
    required this.status,
    required this.products,
    required this.currentPage,
    required this.hasMore,
    required this.searchQuery,
    required this.sortTab,
    required this.priceAscending,
    required this.inStockOnly,
    this.errorMessage,
  });

  factory ProductListState.initial() {
    return const ProductListState(
      status: ProductListStatus.initial,
      products: [],
      currentPage: 0,
      hasMore: true,
      searchQuery: '',
      sortTab: StorefrontSortTab.all,
      priceAscending: true,
      inStockOnly: false,
      errorMessage: null,
    );
  }

  final ProductListStatus status;
  final List<Product> products;
  final int currentPage;
  final bool hasMore;
  final String searchQuery;
  final StorefrontSortTab sortTab;
  final bool priceAscending;
  final bool inStockOnly;
  final String? errorMessage;

  List<Product> get visibleProducts {
    var list = List<Product>.from(products);
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((p) => p.name.toLowerCase().contains(query)).toList();
    }
    if (inStockOnly) {
      list = list.where((p) => p.isInStock).toList();
    }
    switch (sortTab) {
      case StorefrontSortTab.all: {
        break;
      }
      case StorefrontSortTab.newest: {
        list.sort((a, b) => b.id.compareTo(a.id));
        break;
      }
      case StorefrontSortTab.price: {
        list.sort(
          (a, b) =>
              priceAscending
                  ? a.priceVnd.compareTo(b.priceVnd)
                  : b.priceVnd.compareTo(a.priceVnd),
        );
        break;
      }
    }
    return list;
  }

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    StorefrontSortTab? sortTab,
    bool? priceAscending,
    bool? inStockOnly,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      sortTab: sortTab ?? this.sortTab,
      priceAscending: priceAscending ?? this.priceAscending,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
