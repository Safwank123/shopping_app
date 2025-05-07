import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/errors/failure.dart';
import 'package:shopping_app/data/mappers/product_mapper.dart';
import 'package:shopping_app/data/models/product_model.dart';
import 'package:shopping_app/domain/entities/product_entity.dart';
import 'package:shopping_app/domain/entities/review_entity.dart';
import 'package:shopping_app/domain/entities/variant_entity.dart';
import 'package:shopping_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteProductDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getProducts(
        skip: (page - 1) * limit,
        limit: limit,
      );
      final entities = models.map((model) => ProductMapper.modelToEntity(
        model,
        variants: _generateVariants(model),
        reviews: _generateReviews(model),
      )).toList();
      return Right(entities);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      final entity = ProductMapper.modelToEntity(
        model,
        variants: _generateVariants(model),
        reviews: _generateReviews(model),
      );
      return Right(entity);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final models = await remoteDataSource.searchProducts(query);
      final entities = models.map((model) => ProductMapper.modelToEntity(
        model,
        variants: _generateVariants(model),
        reviews: _generateReviews(model),
      )).toList();
      return Right(entities);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.filterProducts(
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        skip: (page - 1) * limit,
        limit: limit,
      );
      final entities = models.map((model) => ProductMapper.modelToEntity(
        model,
        variants: _generateVariants(model),
        reviews: _generateReviews(model),
      )).toList();
      return Right(entities);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic error) {
    if (error is DioException) {
      return ServerFailure(
        error.response?.data?['message'] ?? error.message ?? 'Network error',
      );
    }
    return ServerFailure(error.toString());
  }

  List<VariantEntity> _generateVariants(ProductModel model) {
    // Move this to ProductMapper if used elsewhere
    return [
      if (model.category == 'smartphones')
        const VariantEntity(id: '1', name: '128GB', priceDelta: 0),
      const VariantEntity(id: '2', name: '256GB', priceDelta: 100),
    ];
  }

  List<ReviewEntity> _generateReviews(ProductModel model) {
    // Move this to ProductMapper if used elsewhere
    return [
      ReviewEntity(
        id: '1',
        user: 'TechEnthusiast',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ReviewEntity(
        id: '2',
        user: 'MobileUser',
        rating: 4.8,
        comment: 'Excellent performance',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      )
    ];
  }
}