import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

/// Contract for remote product reads — small, testable surface (ISP).
abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts({
    required int page,
    required int limit,
  });
}

/// HTTP-only responsibility (SRP). Depends on [Dio] for testing (DIP).
final class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ProductModel>> fetchProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.productsPath,
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );

      if (response.statusCode != 200) {
        throw ProductApiException(
          statusCode: response.statusCode ?? 0,
          message: 'Failed to load products',
        );
      }

      final decoded = response.data;
      if (decoded is! List) {
        throw const ProductApiException(
          statusCode: 200,
          message: 'Unexpected response shape',
        );
      }

      return decoded
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = e.message?.isNotEmpty == true
          ? e.message!
          : 'Failed to load products';
      throw ProductApiException(statusCode: code, message: msg);
    }
  }
}

final class ProductApiException implements Exception {
  const ProductApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ProductApiException($statusCode): $message';
}
