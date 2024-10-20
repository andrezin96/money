import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
    required this.label,
    this.cancelButton,
    this.confirmButton,
    required this.descriptionController,
    required this.valueController,
    required this.dateController,
    this.onTap,
  });

  final String label;
  final TextEditingController descriptionController;
  final TextEditingController valueController;
  final TextEditingController dateController;
  final void Function()? onTap;
  final void Function()? cancelButton;
  final void Function()? confirmButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                controller: descriptionController,
                autofocus: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Descrição',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.54,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyMoney.formatter,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    decoration: const InputDecoration(
                      hintText: r'R$ 0,00',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.22,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    onTap: onTap,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: cancelButton,
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: confirmButton,
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
