import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';

class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.inStock});

  final bool inStock;

  @override
  Widget build(BuildContext context) {
    if (inStock) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.inStockGreen,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/images/success.svg',
                  width: 12,
                  height: 12,
                 
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Sẵn kho',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inStockGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DottedLine(
            dashLength: 6,
            dashGapLength: 4,
            lineThickness: 1,
            dashColor: AppColors.dottedLine,
          ),
          const SizedBox(height: 8),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.outStockRed,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/images/fail.svg',
                width: 12,
                height: 12,
                
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Hết hàng',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.outStockRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
