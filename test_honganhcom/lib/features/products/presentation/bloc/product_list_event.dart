import 'product_list_state.dart';

/// User / UI intents for the product list feature.
sealed class ProductListEvent {
  const ProductListEvent();
}

/// Load the first page (full reset).
final class ProductListRequested extends ProductListEvent {
  const ProductListRequested();
}

/// Pull-to-refresh — same as initial load.
final class ProductListRefreshRequested extends ProductListEvent {
  const ProductListRefreshRequested();
}

/// Load the next page when scrolling.
final class ProductListLoadMoreRequested extends ProductListEvent {
  const ProductListLoadMoreRequested();
}

/// Search text changed from the header field.
final class ProductListSearchChanged extends ProductListEvent {
  const ProductListSearchChanged(this.query);

  final String query;
}

/// Sorting tab changed from the header tab row.
final class ProductListSortTabChanged extends ProductListEvent {
  const ProductListSortTabChanged(this.sortTab);

  final StorefrontSortTab sortTab;
}

/// Toggle ascending/descending on the price tab.
final class ProductListPriceSortToggled extends ProductListEvent {
  const ProductListPriceSortToggled();
}

/// In-stock only filter toggled.
final class ProductListInStockOnlyChanged extends ProductListEvent {
  const ProductListInStockOnlyChanged(this.inStockOnly);

  final bool inStockOnly;
}
