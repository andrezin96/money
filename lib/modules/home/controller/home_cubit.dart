import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cache/cache.dart';
import '../../../models/money_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial([]));

  TextEditingController valueController = TextEditingController();

  void getValues() {
    final credits = localStorage.read<List<MoneyModel>>(KeysStorage.credits);
    final debits = localStorage.read<List<MoneyModel>>(KeysStorage.debits);
  }

  Future<void> saveMoney(String key) {
    return localStorage.write(key, valueController.text);
  }
}
