import 'package:flutter/material.dart';

class HomeDialog extends StatelessWidget {
  const HomeDialog({super.key, required this.title, this.cancelButton, this.confirmButton});

  final String title;
  final void Function()? cancelButton;
  final void Function()? confirmButton;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  child: TextButton(
                    onPressed: cancelButton,
                    child: const Text('Não'),
                  ),
                ),
                SizedBox(
                  child: TextButton(
                    onPressed: confirmButton,
                    child: const Text('Sim'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
