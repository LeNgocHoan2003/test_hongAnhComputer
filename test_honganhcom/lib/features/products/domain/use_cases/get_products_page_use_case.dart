import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/product_load_failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Loads a single page of products (application / use-case layer).
final class GetProductsPageUseCase {
  GetProductsPageUseCase(this._repository);

  final ProductRepository _repository;

  Future<Either<ProductLoadFailure, List<Product>>> call({
    required int page,
    required int limit,
  }) {
    return _repository.getProducts(page: page, limit: limit);
  }
}
