import 'package:equatable/equatable.dart';
import 'package:shopping_app/domain/entities/product_entity.dart';
import 'package:shopping_app/domain/entities/variant_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final VariantEntity? variant;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    this.variant,
    required this.quantity,
  });

  double get totalPrice => (product.price + (variant?.priceDelta ?? 0)) * quantity;

  @override
  List<Object?> get props => [id, variant];
}