import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../../../../core/theme/app_colors.dart';
import 'actions_row.dart';
import 'disabled_add_button.dart';
import 'price_block.dart';
import 'product_thumb.dart';
import 'stock_badge.dart';

/// List-style product row matching storefront reference (title + image + price + actions).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showEditStyle = false,
  });

  final Product product;
  final VoidCallback? onTap;

  /// Demo layout with quantity, "Sửa", and remove (matches reference variant).
  final bool showEditStyle;

  @override
  Widget build(BuildContext context) {
    final inStock = product.isInStock;


    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StockBadge(inStock: inStock),
    
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.35,
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ProductThumb(url: product.imageUrl),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: PriceBlock(product: product)),
                  const SizedBox(width: 8),
                  if (inStock)
                    ActionsRow(product: product, editStyle: showEditStyle)
                  else
                    const DisabledAddButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


