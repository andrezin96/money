import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../models/budget_model.dart';
import '../controller/home_cubit.dart';
import 'home_bottom_sheet.dart';
import 'home_card.dart';
import 'home_dialog.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.controller,
  });

  final HomeCubit controller;

  Future<void> showHomeBottomSheet({
    required BuildContext context,
    required String label,
    required void Function() confirmButton,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => HomeBottomSheet(
        label: label,
        descriptionController: controller.descriptionController,
        valueController: controller.valueController,
        dateController: controller.dateController,
        onTap: () async => controller.setDateTime(
          await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          ),
        ),
        confirmButton: () {
          Navigator.pop(context);
          confirmButton.call();
        },
        cancelButton: () {
          controller.clearController();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> showConfirmDialog(BuildContext context, String title, {required void Function() confirmButton}) {
    return showDialog<void>(
      context: context,
      builder: (context) => HomeDialog(
        title: title,
        cancelButton: () => Navigator.pop(context),
        confirmButton: () {
          confirmButton.call();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: controller,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
              child: Column(
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
                          labelFontSize: 18,
                          valueFontSize: 18,
                          value: state.total.toCurrency,
                          onLongPress: () => showConfirmDialog(
                            context,
                            'Deseja realmente apagar tudo?',
                            confirmButton: controller.deleteBudget,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HomeCard(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              label: 'Entradas',
                              value: state.creditsTotal.toCurrency,
                              onTap: () {
                                controller.setDateTime(DateTime.now());
                                showHomeBottomSheet(
                                  context: context,
                                  label: 'Nova Entrada',
                                  confirmButton: () => controller.saveBudget(ValueType.credit),
                                );
                              },
                            ),
                            HomeCard(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              label: 'Saídas',
                              value: state.debitsTotal.toCurrency,
                              onTap: () {
                                controller.setDateTime(DateTime.now());
                                showHomeBottomSheet(
                                  context: context,
                                  label: 'Nova Saída',
                                  confirmButton: () => controller.saveBudget(ValueType.debit),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.budget.values.length,
                      itemBuilder: (context, index) {
                        final item = state.budget.values[index];
                        return ListTile(
                          title: Text('${item.description} - ${controller.dateFormater(item.date)}'),
                          subtitle: Text(item.value.toCurrency),
                          leading: Icon(
                            item.type == ValueType.credit ? Icons.arrow_downward : Icons.arrow_upward,
                            color: item.type == ValueType.credit ? Colors.green : Colors.red,
                          ),
                          onTap: () {
                            controller.selectBudgetValue(index);
                            showHomeBottomSheet(
                              context: context,
                              label: item.type == ValueType.credit ? 'Editar Entrada' : 'Editar Saída',
                              confirmButton: () => controller.editBudgetValue(index),
                            );
                          },
                          onLongPress: () => showConfirmDialog(
                            context,
                            'Deseja realmente apagar?',
                            confirmButton: () => controller.deleteBudgetValue(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
