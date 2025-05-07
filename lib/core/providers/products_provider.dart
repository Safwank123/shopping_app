import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/providers/product_providers.dart';
import '../../domain/entities/product_entity.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(ref),
);

class ProductsNotifier extends StateNotifier<ProductsState> {
  final Ref ref;
  ProductsNotifier(this.ref) : super(ProductsState.initial());

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(status: ProductsStatus.loading);
      
      final products = await ref.read(getProductsUseCaseProvider).execute(
            page: state.page,
            limit: 20,
          );

      state = state.copyWith(
        status: ProductsStatus.loaded,
        products: [...state.products, ...products],
        page: state.page + 1,
        hasReachedMax: products.length < 20,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

enum ProductsStatus { initial, loading, loaded, error }

class ProductsState {
  final ProductsStatus status;
  final List<ProductEntity> products;
  final int page;
  final bool hasReachedMax;
  final String errorMessage;

  ProductsState({
    required this.status,
    required this.products,
    required this.page,
    required this.hasReachedMax,
    required this.errorMessage,
  });

  factory ProductsState.initial() => ProductsState(
        status: ProductsStatus.initial,
        products: [],
        page: 1,
        hasReachedMax: false,
        errorMessage: '',
      );

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? products,
    int? page,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}