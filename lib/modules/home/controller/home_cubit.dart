import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cache/cache.dart';
import '../../../core/helpers/currency_money.dart';
import '../../../models/budget_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial(BudgetModel.empty()));

  TextEditingController valueController = TextEditingController();

  Future<void> getLocalBudget() async {
    emit(HomeLoading(state.budget));
    final budget = localStorage.read<String>(KeysStorage.budget);
    if (budget != null) {
      return emit(HomeInitial(BudgetModel.fromJson(budget)));
    } else {
      emit(HomeInitial(BudgetModel.empty()));
    }
  }

  Future<bool> _saveLocalBudget() async {
    try {
      await localStorage.write(KeysStorage.budget, state.budget.toJson());
      return true;
    } catch (_) {
      emit(
        HomeError(
          state.budget,
          'Não foi possível salvar!',
        ),
      );
      return false;
    }
  }

  BudgetModel _sumTotal(BudgetModel budget) {
    final credits = budget.values.fold<double>(0, (previousValue, element) => previousValue + budget.creditsTotal);
    final debits = budget.values.fold<double>(0, (previousValue, element) => previousValue + budget.debitsTotal);
    return budget.copyWith(
      creditsTotal: debits,
      debitsTotal: debits,
      total: credits - debits,
    );
  }

  Future<void> saveBudget(String type) async {
    final budget = state.budget.copyWith();
    budget.values.add(
      MoneyType(
        description: 'c',
        value: valueController.text.toCurrencyOriginal,
      ),
    );

    final result = await _saveLocalBudget();
    if (result) {
      emit(HomeMoneyAdded(_sumTotal(budget)));
    }
  }
}
