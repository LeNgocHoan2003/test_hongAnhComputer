import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/use_cases/get_products_page_use_case.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

/// Bloc: maps [ProductListEvent] to [ProductListState] (explicit event model).
final class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({required GetProductsPageUseCase getProductsPage})
      : _getProductsPage = getProductsPage,
        super(ProductListState.initial()) {
    on<ProductListRequested>((_, emit) => _loadInitial(emit));
    on<ProductListRefreshRequested>((_, emit) => _loadInitial(emit));
    on<ProductListLoadMoreRequested>(_onLoadMore);
    on<ProductListSearchChanged>(_onSearchChanged);
    on<ProductListSortTabChanged>(_onSortTabChanged);
    on<ProductListPriceSortToggled>(_onPriceSortToggled);
    on<ProductListInStockOnlyChanged>(_onInStockOnlyChanged);
  }

  final GetProductsPageUseCase _getProductsPage;

  static const int _pageSize = ApiConstants.defaultPageSize;

  Future<void> _loadInitial(Emitter<ProductListState> emit) async {
    emit(
      state.copyWith(
        status: ProductListStatus.loading,
        clearErrorMessage: true,
        products: const [],
        currentPage: 0,
        hasMore: true,
      ),
    );

    final result = await _getProductsPage(page: 1, limit: _pageSize);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (batch) => emit(
        state.copyWith(
          status: ProductListStatus.ready,
          products: batch,
          currentPage: 1,
          hasMore: batch.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    ProductListLoadMoreRequested event,
    Emitter<ProductListState> emit,
  ) async {
    if (!state.hasMore ||
        state.status == ProductListStatus.loading ||
        state.status == ProductListStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: ProductListStatus.loadingMore));

    final result =
        await _getProductsPage(page: state.currentPage + 1, limit: _pageSize);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (batch) {
        if (batch.isEmpty) {
          emit(
            state.copyWith(
              status: ProductListStatus.ready,
              hasMore: false,
            ),
          );
        } else {
          final nextPage = state.currentPage + 1;
          emit(
            state.copyWith(
              status: ProductListStatus.ready,
              products: [...state.products, ...batch],
              currentPage: nextPage,
              hasMore: batch.length >= _pageSize,
            ),
          );
        }
      },
    );
  }

  void _onSearchChanged(
    ProductListSearchChanged event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSortTabChanged(
    ProductListSortTabChanged event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(sortTab: event.sortTab));
  }

  void _onPriceSortToggled(
    ProductListPriceSortToggled event,
    Emitter<ProductListState> emit,
  ) {
    emit(
      state.copyWith(
        sortTab: StorefrontSortTab.price,
        priceAscending: !state.priceAscending,
      ),
    );
  }

  void _onInStockOnlyChanged(
    ProductListInStockOnlyChanged event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(inStockOnly: event.inStockOnly));
  }
}
