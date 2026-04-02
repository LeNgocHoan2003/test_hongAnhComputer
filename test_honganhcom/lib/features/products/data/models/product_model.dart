import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

/// DTO + mapping — isolates JSON shape from the domain (Open/Closed).
class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
    this.description,
    this.oldPrice,
  });

  /// Supports interview API doc (`name`, `description`, `category`, `stock`)
  /// and my-json-server demo (`title`, `body`, `inStock`, optional `category`).
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? json['title'] as String?;
    if (name == null || name.isEmpty) {
      throw FormatException('Product JSON missing name/title');
    }

    final old = json['oldPrice'];
    return ProductModel(
      id: _asInt(json['id']),
      name: name,
      price: _asInt(json['price']),
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'product',
      stock: _readStock(json),
      description: json['description'] as String? ?? json['body'] as String?,
      oldPrice: old == null ? null : _asInt(old),
    );
  }

  static int _asInt(Object? value) {
    if (value == null) {
      throw FormatException('Expected number, got null');
    }
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.parse(value);
    throw FormatException('Expected int-compatible value, got $value');
  }

  static int _readStock(Map<String, dynamic> json) {
    final stock = json['stock'];
    if (stock != null) return _asInt(stock);
    final inStock = json['inStock'];
    if (inStock is bool) return inStock ? 1 : 0;
    return 0;
  }

  final int id;
  final String name;
  final int price;
  final String image;
  final String category;
  final int stock;
  final String? description;
  final int? oldPrice;

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      priceVnd: price,
      imageUrl: image,
      category: category,
      stock: stock,
      description: description,
      oldPriceVnd: oldPrice,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, price, oldPrice, image, category, stock, description];
}
