import 'package:contacts/core/utils/hints.dart';
import 'package:flutter/material.dart';

class ConfirmDismiss extends StatelessWidget {
  const ConfirmDismiss({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Contact'),
      content:  Text(Hints.sure),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}