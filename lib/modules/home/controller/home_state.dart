part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState(this.budget);

  final BudgetModel budget;

  double get creditsTotal => budget.creditsTotal;
  double get debitsTotal => budget.debitsTotal;
  double get total => budget.total;

  @override
  List<Object> get props => [budget];
}

final class HomeInitial extends HomeState {
  const HomeInitial(super.budget);
}

final class HomeLoading extends HomeState {
  const HomeLoading(super.budget);
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(super.budget);
}

final class HomeMoneyAdded extends HomeState {
  const HomeMoneyAdded(super.budget);
}

final class HomeValueRemoved extends HomeState {
  const HomeValueRemoved(super.budget);
}

final class HomeValueEdited extends HomeState {
  const HomeValueEdited(super.budget);
}

final class HomeError extends HomeState {
  const HomeError(super.budget, this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
