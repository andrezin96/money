import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cache/cache.dart';
import '../../../models/money_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial([]));

  List<MoneyModel> getMoneyList() {
    return localStorage.read<List<MoneyModel>>(KeysStorage.list) ?? [];
  }
}
