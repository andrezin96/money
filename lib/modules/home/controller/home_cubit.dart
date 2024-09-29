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
  TextEditingController descriptionController = TextEditingController();

  Future<void> getLocalBudget() async {
    emit(HomeLoading(state.budget));
    final budget = localStorage.read<String>(KeysStorage.budget);
    if (budget != null) {
      emit(HomeInitial(BudgetModel.fromJson(budget)));
    } else {
      emit(HomeInitial(BudgetModel.empty()));
    }
  }

  Future<bool> _saveLocalBudget(BudgetModel budget) async {
    try {
      await localStorage.write(KeysStorage.budget, budget.toJson());
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
    final creditValues = budget.values.where((element) => element.type == ValueType.credit);
    final debitsValues = budget.values.where((element) => element.type == ValueType.debit);
    final credits = creditValues.fold<double>(0, (previousValue, element) => previousValue + element.value);
    final debits = debitsValues.fold<double>(0, (previousValue, element) => previousValue + element.value);
    final total = credits - debits;
    return budget.copyWith(
      creditsTotal: credits,
      debitsTotal: debits,
      total: total,
    );
  }

  Future<void> saveBudget(ValueType type) async {
    emit(HomeLoading(state.budget));
    final updatedValues = List<MoneyType>.from(state.budget.values)
      ..add(
        MoneyType(
          description: descriptionController.text,
          type: type,
          value: valueController.text.toCurrencyOriginal,
        ),
      );

    final updatedBudget = state.budget.copyWith(values: updatedValues);
    final budget = _sumTotal(updatedBudget);

    final result = await _saveLocalBudget(budget);
    if (result) {
      emit(HomeMoneyAdded(budget));
      _clearController();
    }
  }

  void selectBudgetValue(int index) {
    final budget = state.budget.copyWith();
    if (budget.values.isNotEmpty) {
      descriptionController.text = budget.values[index].description;
      valueController.text = budget.values[index].value.toCurrencyInitial;
    }
  }

  Future<void> editBudgetValue(int index) async {
    final budget = state.budget.copyWith();
    if (budget.values.isNotEmpty) {
      budget.values[index] = MoneyType(
        description: descriptionController.text,
        type: budget.values[index].type,
        value: valueController.text.toCurrencyOriginal,
      );

      final result = await _saveLocalBudget(budget);
      if (result) {
        emit(HomeValueEdited(budget));
        _clearController();
      }
    }
  }

  void deleteBudgetValue(int index) {
    final budget = state.budget.copyWith();
    if (budget.values.isNotEmpty) {
      budget.values.removeAt(index);
      emit(HomeValueRemoved(_sumTotal(budget)));
    }
    _saveLocalBudget(budget);
  }

  Future<void> deleteBudget() async {
    await localStorage.remove(KeysStorage.budget);
    emit(HomeInitial(BudgetModel.empty()));
    _clearController();
  }

  void _clearController() {
    descriptionController.clear();
    valueController.clear();
  }
}
