import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../controller/home_cubit.dart';
import 'home_bottom_sheet.dart';
import 'home_card.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.controller,
  });

  final HomeCubit controller;

  Future<void> showHomeBottomSheet(BuildContext context, String type) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => HomeBottomSheet(
        controller: controller.valueController,
        confirmButton: () {
          controller.saveBudget(type);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocConsumer<HomeCubit, HomeState>(
                bloc: controller,
                listener: (context, state) {
                  if (state is HomeMoneyAdded) {
                    return log(state.budget.values.length.toString());
                  }
                },
                builder: (context, state) {
                  log(state.toString());
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      HomeCard(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        label: 'Saldo',
                        value: state.budget.total.toCurrency,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HomeCard(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            label: 'Entradas',
                            value: state.budget.creditsTotal.toCurrency,
                            onTap: () => showHomeBottomSheet(context, 'c'),
                          ),
                          HomeCard(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            label: 'Saídas',
                            value: state.budget.debitsTotal.toCurrency,
                            onTap: () => showHomeBottomSheet(context, 'd'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
