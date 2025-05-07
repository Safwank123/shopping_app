import '../../domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/variant_entity.dart';
import '../models/product_model.dart';

class ProductMapper {
  static ProductEntity modelToEntity(ProductModel model, {required List<ReviewEntity> reviews, required List<VariantEntity> variants}) {
    return ProductEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      price: model.price,
      discountPercentage: model.discountPercentage,
      rating: model.rating,
      stock: model.stock,
      brand: model.brand,
      category: model.category,
      thumbnail: model.thumbnail,
      images: model.images,
      variants: _generateVariants(model),
      reviews: _generateReviews(model),
    );
  }

  static List<VariantEntity> _generateVariants(ProductModel model) {
    // Generate mock variants based on product category
    return [
      if (model.category == 'smartphones')
        const VariantEntity(id: '1', name: '128GB', priceDelta: 0),
      const VariantEntity(id: '2', name: '256GB', priceDelta: 100),
    ];
  }

  static List<ReviewEntity> _generateReviews(ProductModel model) {
    // Generate mock reviews
    return [
      ReviewEntity(
        id: '1',
        user: 'TechEnthusiast',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewEntity(
        id: '2',
        user: 'MobileUser',
        rating: 4.8,
        comment: 'Excellent performance',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}