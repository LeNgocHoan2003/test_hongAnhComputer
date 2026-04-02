import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/product.dart';

class PriceBlock extends StatelessWidget {
  const PriceBlock({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final oldP = product.oldPriceVnd;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (oldP != null && oldP > product.priceVnd) ...[
          Text(
            formatVnd(oldP),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          formatVnd(product.priceVnd),
          style: const TextStyle(
            fontFamily: 'Anek Latin',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
