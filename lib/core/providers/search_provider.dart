import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/providers/product_providers.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.read);
});

class SearchNotifier extends StateNotifier<SearchState> {
  final Reader _read;
  Timer? _debounce;

  SearchNotifier(this._read) : super(SearchState.initial());

  void search(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        state = SearchState.initial();
        return;
      }

      state = state.copyWith(status: SearchStatus.loading);
      
      final result = await _read(productRepositoryProvider).searchProducts(query);
      state = result.fold(
        (failure) => state.copyWith(
          status: SearchStatus.error,
          error: failure.message,
        ),
        (products) => state.copyWith(
          status: SearchStatus.loaded,
          suggestions: products.take(5).toList(),
        ),
      );
    });
  }
}