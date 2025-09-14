import 'package:flutter/material.dart';

void makeShowChoicesPicker<T extends Enum>(
  BuildContext context, {
  required List<T> choices,
  required T selectedItem,
  required Widget Function(T choice) labelBuilder,
  required void Function(T choice) onSelectedItemChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(top: 12),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: choices
              .map((value) {
                return RadioListTile<T>(
                  title: labelBuilder(value),
                  value: value,
                  groupValue: selectedItem,
                  onChanged: (value) {
                    if (value != null) onSelectedItemChanged(value);
                    Navigator.of(context).pop();
                  },
                );
              })
              .toList(growable: false),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
