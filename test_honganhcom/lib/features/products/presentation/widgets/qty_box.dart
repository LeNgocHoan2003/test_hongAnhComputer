import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QtyBox extends StatelessWidget {
  const QtyBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 999,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final controller = TextEditingController(text: value.toString());
        final nextValue = await showDialog<int>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Enter quantity'),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: '1 - 999'),
                onSubmitted: (_) {
                  final parsed = int.tryParse(controller.text.trim());
                  Navigator.of(dialogContext).pop(parsed);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final parsed = int.tryParse(controller.text.trim());
                    Navigator.of(dialogContext).pop(parsed);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        if (nextValue == null) {
          return;
        }

        final clamped = nextValue.clamp(min, max);
        onChanged(clamped);
      },
      child: Container(
        width: 44,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC5C5C7)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(
          '$value',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
