import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';
import '../controller/home_cubit.dart';
import 'home_card.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.controller,
  });

  final HomeCubit controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money'),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                HomeCard(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Saldo',
                  value: '1000000',
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => Container(
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
                              controller: controller.valueController,
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeCard(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      label: 'Entradas',
                      value: '100000',
                    ),
                    HomeCard(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      label: 'Saídas',
                      value: '1000',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
