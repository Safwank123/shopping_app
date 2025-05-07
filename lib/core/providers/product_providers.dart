import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/domain/repositories/product_repository_impl.dart';
import '../../domain/use_cases/get_products_use_case.dart';

final dioProvider = Provider((ref) => Dio());

final remoteDataSourceProvider = Provider((ref) => 
  DummyJsonDataSource(ref.watch(dioProvider)));

final productRepositoryProvider = Provider((ref) => 
  ProductRepositoryImpl(ref.watch(remoteDataSourceProvider)));

final getProductsUseCaseProvider = Provider((ref) => 
  GetProductsUseCase(ref.watch(productRepositoryProvider)));