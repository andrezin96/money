import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../cache/cache.dart';
import '../../../core/helpers/currency_money.dart';
import '../../../models/budget_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial(BudgetModel.empty()));

  TextEditingController valueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String dateFormater(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String setDateTime(DateTime? date) {
    return dateController.text = dateFormater(date ?? DateTime.now());
  }

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

  Iterable<MoneyType> _incrementElement(BudgetModel budget, ValueType type) {
    return budget.values.where((element) => element.type == type);
  }

  double _sumElements(Iterable<MoneyType> list) {
    return list.fold<double>(0, (previousValue, element) => previousValue + element.value);
  }

  BudgetModel _sumTotal(BudgetModel budget) {
    final creditValues = _incrementElement(budget, ValueType.credit);
    final debitsValues = _incrementElement(budget, ValueType.debit);
    return budget.copyWith(
      creditsTotal: _sumElements(creditValues),
      debitsTotal: _sumElements(debitsValues),
      total: _sumElements(creditValues) - _sumElements(debitsValues),
    );
  }

  Future<void> saveBudget(ValueType type) async {
    emit(HomeLoading(state.budget));
    final updatedValues = List<MoneyType>.from(state.budget.values)
      ..add(
        MoneyType(
          description: descriptionController.text,
          date: DateFormat('dd/MM/yyyy HH:mm:ss').parse(dateController.text),
          type: type,
          value: valueController.text.toCurrencyOriginal,
        ),
      );

    updatedValues.sort((a, b) => b.date.compareTo(a.date));
    final updatedBudget = state.budget.copyWith(values: updatedValues);
    final budget = _sumTotal(updatedBudget);

    final result = await _saveLocalBudget(budget);
    if (result) {
      emit(HomeMoneyAdded(budget));
      clearController();
    }
  }

  void selectBudgetValue(int index) {
    final budget = state.budget.copyWith();
    if (budget.values.isNotEmpty) {
      descriptionController.text = budget.values[index].description;
      dateController.text = DateFormat('dd/MM/yyyy HH:mm:ss').format(budget.values[index].date);
      valueController.text = budget.values[index].value.toCurrencyInitial;
    }
  }

  Future<void> editBudgetValue(int index) async {
    final budget = state.budget.copyWith();
    if (budget.values.isNotEmpty) {
      budget.values[index] = MoneyType(
        description: descriptionController.text,
        date: DateFormat('dd/MM/yyyy HH:mm:ss').parse(dateController.text),
        type: budget.values[index].type,
        value: valueController.text.toCurrencyOriginal,
      );

      budget.values.sort((a, b) => b.date.compareTo(a.date));

      final result = await _saveLocalBudget(budget);
      if (result) {
        emit(HomeValueEdited(_sumTotal(budget)));
        clearController();
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
    clearController();
  }

  void clearController() {
    descriptionController.clear();
    valueController.clear();
    dateController.clear();
  }
}
