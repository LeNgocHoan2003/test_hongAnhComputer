import 'package:flutter/material.dart';

class ProductThumb extends StatelessWidget {
  const ProductThumb({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 48,
        height: 48,
        child: url.isEmpty
            ? ColoredBox(
                color: const Color(0xFFE8E8ED),
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey.shade500,
                  size: 48,
                ),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: const Color(0xFFE8E8ED),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey.shade500,
                    size: 48,
                  ),
                ),
              ),
      ),
    );
  }
}
