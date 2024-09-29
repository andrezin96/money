import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key, required this.controller, this.cancelButton, this.confirmButton});

  final TextEditingController controller;
  final void Function()? cancelButton;
  final void Function()? confirmButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Nova Entrada',
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextFormField(
              controller: controller,
              autofocus: true,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => cancelButton ?? Navigator.pop(context),
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
    );
  }
}
