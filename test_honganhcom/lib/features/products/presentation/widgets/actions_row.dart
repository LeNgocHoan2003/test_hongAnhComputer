import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import 'qty_box.dart';

class ActionsRow extends StatefulWidget {
  const ActionsRow({super.key, required this.product, required this.editStyle});

  final Product product;
  final bool editStyle;

  @override
  State<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<ActionsRow> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.product.stock <= 0 ? 1 : widget.product.stock.clamp(1, 999);
  }

  @override
  void didUpdateWidget(covariant ActionsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.stock != widget.product.stock) {
      qty = widget.product.stock <= 0 ? 1 : widget.product.stock.clamp(1, 999);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editStyle) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QtyBox(
            value: qty,
            onChanged: (newValue) => setState(() => qty = newValue),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              minimumSize: const Size(40, 40),
              backgroundColor: AppColors.navyButton,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Sửa', style: TextStyle(fontSize: 15)),
          ),
          const SizedBox(width: 6),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.outStockRed,
              side: const BorderSide(color: AppColors.outStockRed),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              minimumSize: const Size(40, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(Icons.close, size: 18),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QtyBox(
          value: qty > 100 ? 100 : qty,
          onChanged: (newValue) => setState(() => qty = newValue),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            minimumSize: const Size(40, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Thêm vào giỏ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
