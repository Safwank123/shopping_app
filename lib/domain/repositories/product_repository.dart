
import 'package:dartz/dartz.dart';
import 'package:shopping_app/core/errors/failure.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(int id);
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<ProductEntity>>> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });
}