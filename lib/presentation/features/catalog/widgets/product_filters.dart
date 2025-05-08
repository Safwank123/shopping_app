import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/providers/products_provider.dart';

class ProductFilters extends ConsumerWidget {
  const ProductFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final state = ref.watch(productsProvider);
    
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildCategoryChips(categories, state, ref),
            _buildFilterButton(context, ref),
            _buildSortButton(context, ref),
          ],
        ),
        if (state.minPrice != null || state.maxPrice != null)
          _buildPriceRangeDisplay(state, ref),
      ],
    );
  }

  Widget _buildCategoryChips(List<String> categories, ProductsState state, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (ctx, index) => FilterChip(
          label: Text(categories[index]),
          selected: state.selectedCategory == categories[index],
          onSelected: (selected) => ref.read(productsProvider.notifier)
            .setCategory(selected ? categories[index] : null),
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ProductSort>(
      onSelected: (sort) => ref.read(productsProvider.notifier).setSort(sort),
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: ProductSort.newest,
          child: Text('Newest First'),
        ),
        PopupMenuItem(
          value: ProductSort.priceAsc,
          child: Text('Price: Low to High'),
        ),
        PopupMenuItem(
          value: ProductSort.priceDesc,
          child: Text('Price: High to Low'),
        ),
        PopupMenuItem(
          value: ProductSort.rating,
          child: Text('Top Rated'),
        ),
      ],
    );
  }
}
void showPriceFilter(BuildContext context, WidgetRef ref) {
  final state = ref.read(productsProvider);
  double min = state.minPrice ?? 0;
  double max = state.maxPrice ?? 10000;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text('Price Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RangeSlider(
              values: RangeValues(min, max),
              max: 10000,
              divisions: 100,
              labels: RangeLabels(
                '\$$min',
                '\$$max',
              ),
              onChanged: (values) => setState(() {
                min = values.start;
                max = values.end;
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${min.toStringAsFixed(2)}'),
                Text('\$${max.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(productsProvider.notifier).setPriceRange(min, max);
              Navigator.pop(ctx);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    ),
  );
}