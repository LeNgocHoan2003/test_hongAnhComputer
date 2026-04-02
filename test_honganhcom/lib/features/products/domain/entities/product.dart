import 'package:equatable/equatable.dart';

/// Domain entity — framework-agnostic product (Single Responsibility).
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.priceVnd,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
    this.oldPriceVnd,
  });

  final int id;
  final String name;
  final int priceVnd;
  /// Original list price when on sale (API `oldPrice`); null if none.
  final int? oldPriceVnd;
  final String imageUrl;
  final String category;
  final int stock;
  final String? description;

  bool get isInStock => stock > 0;

  @override
  List<Object?> get props =>
      [id, name, priceVnd, oldPriceVnd, imageUrl, category, stock, description];
}
