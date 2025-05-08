// products_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/providers/product_providers.dart';
import '../../domain/entities/product_entity.dart';

enum ProductsStatus { initial, loading, loaded, error }
enum ProductSort { priceAsc, priceDesc, rating, newest }

class ProductsState {
  final ProductsStatus status;
  final List<ProductEntity> products;
  final int page;
  final bool hasReachedMax;
  final String errorMessage;
  final String? selectedCategory;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final ProductSort sortBy;
  final String searchQuery;

  const ProductsState({
    required this.status,
    required this.products,
    required this.page,
    required this.hasReachedMax,
    required this.errorMessage,
    this.selectedCategory,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy = ProductSort.newest,
    this.searchQuery = '',
  });

  factory ProductsState.initial() => const ProductsState(
        status: ProductsStatus.initial,
        products: [],
        page: 1,
        hasReachedMax: false,
        errorMessage: '',
        sortBy: ProductSort.newest,
        searchQuery: '',
      );

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? products,
    int? page,
    bool? hasReachedMax,
    String? errorMessage,
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    ProductSort? sortBy,
    String? searchQuery,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// products_notifier.dart
class ProductsNotifier extends StateNotifier<ProductsState> {
  final Ref ref;

  ProductsNotifier(this.ref) : super(ProductsState.initial());

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(
        status: ProductsStatus.loading,
        errorMessage: '',
      );

      final result = await ref.read(productRepositoryProvider).filterProducts(
            category: state.selectedCategory,
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
            minRating: state.minRating,
            page: state.page,
          );

      result.fold(
        (failure) => state = state.copyWith(
          status: ProductsStatus.error,
          errorMessage: failure.message,
        ),
        (newProducts) {
          final allProducts = [...state.products, ...newProducts];
          final sortedProducts = _applySorting(allProducts);

          state = state.copyWith(
            status: ProductsStatus.loaded,
            products: sortedProducts,
            page: state.page + 1,
            hasReachedMax: newProducts.isEmpty,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to load products: ${e.toString()}',
      );
    }
  }

  void setCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      page: 1,
      products: [],
      hasReachedMax: false,
    );
    loadProducts();
  }

  void setPriceRange(double? min, double? max) {
    state = state.copyWith(
      minPrice: min,
      maxPrice: max,
      page: 1,
      products: [],
      hasReachedMax: false,
    );
    loadProducts();
  }

  void setMinRating(double? rating) {
    state = state.copyWith(
      minRating: rating,
      page: 1,
      products: [],
      hasReachedMax: false,
    );
    loadProducts();
  }

  void setSort(ProductSort sort) {
    state = state.copyWith(
      sortBy: sort,
      products: _applySorting(state.products),
    );
  }

  List<ProductEntity> _applySorting(List<ProductEntity> products) {
    switch (state.sortBy) {
      case ProductSort.priceAsc:
        return products..sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDesc:
        return products..sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.rating:
        return products..sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSort.newest:
        return products..sort((a, b) => b.id.compareTo(a.id));
    }
  }

  void searchProducts(String query) {
    state = state.copyWith(
      searchQuery: query,
      page: 1,
      products: [],
      hasReachedMax: false,
    );
    loadProducts();
  }

  void clearFilters() {
    state = ProductsState.initial();
    loadProducts();
  }
}