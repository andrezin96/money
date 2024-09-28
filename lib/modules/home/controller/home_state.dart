part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState(this.list);

  final List<MoneyModel> list;

  @override
  List<Object> get props => [list];
}

final class HomeInitial extends HomeState {
  const HomeInitial(super.list);
}

final class HomeLoading extends HomeState {
  const HomeLoading(super.list);
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(super.list);
}

final class HomeError extends HomeState {
  const HomeError(super.list);
}
