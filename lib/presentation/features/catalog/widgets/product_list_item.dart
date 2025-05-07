import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.thumbnail, width: 50, height: 50),
        title: Text(product.title),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, '/product/${product.id}'),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }
}