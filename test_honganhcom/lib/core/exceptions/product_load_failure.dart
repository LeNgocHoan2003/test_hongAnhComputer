import 'package:equatable/equatable.dart';

/// Failure type for failed product loads — shared across layers (no data types in UI).
final class ProductLoadFailure extends Equatable implements Exception {
  const ProductLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
