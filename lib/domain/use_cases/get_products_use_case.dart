
import 'package:dartz/dartz.dart';
import 'package:shopping_app/core/errors/failure.dart' show Failure;
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> execute() {
    return repository.getProducts();
  }
}