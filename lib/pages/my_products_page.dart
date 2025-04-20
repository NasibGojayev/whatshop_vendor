import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc_management/product_bloc/product_bloc.dart';
import '../bloc_management/product_bloc/product_state.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mənim Məhsullarım'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context,state) {
            if(state is ProductLoadedState){
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(product: product);
                },
              );
            }
            else if(state is ProductErrorState){
              return Text(state.error);
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.product.isActive;
  }

  String get lowestAvailablePrice {
    final availableSizes = widget.product.sizeOptions
        .where((size) => size['isAvailable'] == true)
        .toList();

    if (availableSizes.isEmpty) return 'N/A';

    final lowestPrice = availableSizes
        .map((size) => size['price'] as double)
        .reduce((a, b) => a < b ? a : b);

    return '₼ ${lowestPrice.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      color: isActive ? Colors.white : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            GestureDetector(
              onTap: () {
                context.push('/product-preview', extra: widget.product);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                    image: NetworkImage(widget.product.images.first),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.push('/product-preview', extra: widget.product);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Category
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Price and Size Options
                    Row(
                      children: [
                        Text(
                          lowestAvailablePrice,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.product.sizeOptions.where((s) => s['isAvailable'] == true).length} sizes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Status and Actions
                    Row(
                      children: [
                        // Status Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isActive ? 'Aktiv' : 'Qeyri aktiv',
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Toggle Switch
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),

                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          color: Colors.grey,
                          onPressed: () {
                            context.push('/edit_product', extra: widget.product);
                          },
                        ),

                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: Colors.red.shade300,
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Bu məhsulu silmək istədiyinizdən əminsiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Yox'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted')),
              );
            },
            child: const Text(
              'Sil',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
