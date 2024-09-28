// ignore_for_file: public_member_api_docs, sort_constructors_first
enum Moneytype {
  credit,
  debit,
  none,
}

class MoneyModel {
  const MoneyModel({
    required this.value,
    required this.type,
  });
  final int value;
  final Moneytype type;

  MoneyModel copyWith({
    int? value,
    Moneytype? type,
  }) {
    return MoneyModel(
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }

  factory MoneyModel.empty() {
    return const MoneyModel(
      value: 0,
      type: Moneytype.none,
    );
  }
}
