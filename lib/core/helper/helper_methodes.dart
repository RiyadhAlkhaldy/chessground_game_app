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
// هذه الدالة تعرض نافذة تأكيد الاستسلام
Future<bool?> showExitConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('إنهاء اللعبة؟'),
        content: Text('هل أنت متأكد أنك تريد الاستسلام وإنهاء اللعبة؟'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // لا تسمح بالخروج
            },
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // تسمح بالخروج
            },
            child: Text('استسلام'),
          ),
        ],
      );
    },
  );
}

// هذه الدالة الجديدة تعرض نافذة "نهاية اللعبة"
Future<void> showGameOverDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // يمنع إغلاقها بالضغط خارجها
    builder: (context) {
      return AlertDialog(
        title: Text('انتهت اللعبة!'),
        content: Text(
          'لقد خسرت هذه اللعبة. يمكنك الآن العودة إلى الصفحة الرئيسية.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق النافذة المنبثقة
            },
            child: Text('حسناً'),
          ),
        ],
      );
    },
  );
}
