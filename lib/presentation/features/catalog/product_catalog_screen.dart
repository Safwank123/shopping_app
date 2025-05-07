import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopping_app/core/providers/products_provider.dart';
import 'package:shopping_app/presentation/features/catalog/widgets/product_grid_item.dart';
import 'package:shopping_app/presentation/features/catalog/widgets/product_list_item.dart';

class ProductCatalogScreen extends ConsumerStatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  ConsumerState<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ProductCatalogScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadProducts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      ref.read(productsProvider.notifier).loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: 300.ms,
              child: _isGridView
                  ? const Icon(Icons.list)
                  : const Icon(Icons.grid_view),
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ProductsState state) {
    if (state.status == ProductsStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ProductsStatus.error) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productsProvider.notifier).loadProducts();
      },
      child: AnimatedSwitcher(
        duration: 300.ms,
        child: _isGridView ? _buildGridView(state) : _buildListView(state),
      ),
    );
  }

  Widget _buildGridView(ProductsState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: state.products.length + (state.hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return ProductGridItem(product: state.products[index]);
      },
    );
  }

  Widget _buildListView(ProductsState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: state.products.length + (state.hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return ProductListItem(product: state.products[index]);
      },
    );
  }
}