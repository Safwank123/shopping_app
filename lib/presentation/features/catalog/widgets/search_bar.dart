import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/providers/search_provider.dart';
import 'package:shopping_app/domain/entities/product_entity.dart';

class ProductSearchBar extends ConsumerWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    
    return Autocomplete<ProductEntity>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable.empty();
        return searchState.suggestions;
      },
      onSelected: (product) => 
        context.push('/product/${product.id}'),
      fieldViewBuilder: (ctx, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => controller.clear(),
            ),
          ),
          onChanged: (value) => ref.read(searchProvider.notifier).search(value),
        );
      },
      optionsViewBuilder: (ctx, onSelected, options) => Material(
        elevation: 4,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: options.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (ctx, index) {
            final product = options.elementAt(index);
            return ListTile(
              leading: Image.network(product.thumbnail, width: 40),
              title: Text(product.title),
              subtitle: Text('\$${product.price}'),
              onTap: () => onSelected(product),
            );
          },
        ),
      ),
    );
  }
}