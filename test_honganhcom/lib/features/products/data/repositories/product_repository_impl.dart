import 'dart:developer' as developer;

import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/product_load_failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

/// Orchestrates data sources and maps to domain (SRP).
final class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final ProductRemoteDataSource _remote;

  @override
  Future<Either<ProductLoadFailure, List<Product>>> getProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final models = await _remote.fetchProducts(page: page, limit: limit);
      return right(models.map((m) => m.toEntity()).toList());
    } on ProductApiException catch (e) {
      return left(ProductLoadFailure(e.message));
    } on FormatException catch (e) {
      return left(ProductLoadFailure('Invalid product data: ${e.message}'));
    } catch (e, st) {
      developer.log(
        'getProducts failed',
        error: e,
        stackTrace: st,
      );
      return left(const ProductLoadFailure('Something went wrong'));
    }
  }
}
