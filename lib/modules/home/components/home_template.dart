import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../models/budget_model.dart';
import '../controller/home_cubit.dart';
import 'home_bottom_sheet.dart';
import 'home_card.dart';
import 'home_dialog.dart';
import 'home_tile.dart';

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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      HomeCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        label: 'Saldo disponível',
                        value: state.total.toCurrency,
                        valueFontSize: 22,
                        onLongPress: () => showConfirmDialog(
                          context,
                          'Deseja realmente apagar tudo?',
                          confirmButton: controller.deleteBudget,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeCard(
                            height: 60,
                            width: MediaQuery.sizeOf(context).width * 0.38,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.grey[800],
                            label: 'Crédito',
                            value: state.creditsTotal.toCurrency,
                            valueFontSize: 18,
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
                            height: 60,
                            width: MediaQuery.sizeOf(context).width * 0.38,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.grey[800],
                            label: 'Débito',
                            value: state.debitsTotal.toCurrency,
                            valueFontSize: 18,
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
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white12,
                    ),
                    itemCount: state.budget.values.length,
                    itemBuilder: (context, index) {
                      final item = state.budget.values[index];
                      return HomeTile(
                        description: item.description,
                        value: item.value.toCurrency,
                        date: item.date,
                        type: item.type,
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
        );
      },
    );
  }
}
