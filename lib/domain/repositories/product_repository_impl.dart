import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/errors/failure.dart';
import 'package:shopping_app/data/mappers/product_mapper.dart';
import 'package:shopping_app/data/models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/repositories/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {
  final RemoteProductDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await remoteDataSource.getProducts();
      final entities = models.map(ProductMapper.modelToEntity).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      final entity = ProductMapper.modelToEntity(model);
      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final models = await remoteDataSource.searchProducts(query);
      final entities = models.map(ProductMapper.modelToEntity).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      final models = await remoteDataSource.filterProducts(
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      );
      final entities = models.map(ProductMapper.modelToEntity).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Additional helper methods for mock data generation
  List<VariantEntity> _generateVariants(ProductModel model) {
    return [
      if (model.category == 'smartphones')
        const VariantEntity(id: '1', name: '128GB', priceDelta: 0),
      const VariantEntity(id: '2', name: '256GB', priceDelta: 100),
    ];
  }

  List<ReviewEntity> _generateReviews(ProductModel model) {
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