import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DisabledAddButton extends StatelessWidget {
  const DisabledAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.disableButton,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disableButton,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(40, 40),
        ),
        child: const Text(
          'Thêm vào giỏ',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
