import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, void Function() onDeleteNote) {
  showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: const Text('Do you want to delete this note?'),
          content: const Text('This action cannot be undone'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: onDeleteNote,
              child: const Text('Delete'),
            )
          ],
        );
      });
}
