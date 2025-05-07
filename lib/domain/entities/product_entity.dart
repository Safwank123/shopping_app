import 'package:equatable/equatable.dart';
import 'package:shopping_app/domain/entities/review_entity.dart';
import 'package:shopping_app/domain/entities/variant_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final List<VariantEntity> variants;
  final List<ReviewEntity> reviews;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    this.variants = const [],
    this.reviews = const [],
  });

  @override
  List<Object?> get props => [id];
}