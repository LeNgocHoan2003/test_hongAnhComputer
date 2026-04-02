import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/product_load_failure.dart';
import '../entities/product.dart';

/// Repository contract — presentation depends on this abstraction (DIP).
abstract interface class ProductRepository {
  /// Fetches one page of products. Page index starts at 1 (JSON Server).
  Future<Either<ProductLoadFailure, List<Product>>> getProducts({
    required int page,
    required int limit,
  });
}
