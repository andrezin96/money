import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum ValueType {
  credit,
  debit,
  none,
}

class BudgetModel {
  const BudgetModel({
    required this.values,
    required this.creditsTotal,
    required this.debitsTotal,
    required this.total,
  });
  final List<MoneyType> values;
  final double creditsTotal;
  final double debitsTotal;
  final double total;

  BudgetModel copyWith({
    String? description,
    List<MoneyType>? values,
    double? creditsTotal,
    double? debitsTotal,
    double? total,
  }) {
    return BudgetModel(
      values: values ?? this.values,
      creditsTotal: creditsTotal ?? this.creditsTotal,
      debitsTotal: debitsTotal ?? this.debitsTotal,
      total: total ?? this.total,
    );
  }

  factory BudgetModel.empty() {
    return const BudgetModel(
      values: [],
      creditsTotal: 0,
      debitsTotal: 0,
      total: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'values': values.map((value) => value.toMap()).toList(),
      'creditsTotal': creditsTotal,
      'debitsTotal': debitsTotal,
      'total': total,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      values: (map['values'] as List? ?? []).map((value) => MoneyType.fromMap(value as Map<String, dynamic>)).toList(),
      creditsTotal: map['creditsTotal'] as double,
      debitsTotal: map['debitsTotal'] as double,
      total: map['total'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) => BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MoneyType {
  const MoneyType({
    required this.description,
    required this.date,
    required this.type,
    required this.value,
  });

  final String description;
  final DateTime date;
  final ValueType type;
  final double value;

  MoneyType copyWith({
    String? description,
    DateTime? date,
    ValueType? type,
    double? value,
  }) {
    return MoneyType(
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  factory MoneyType.empty() {
    return MoneyType(
      description: '',
      date: DateTime.now(),
      type: ValueType.none,
      value: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'date': date.toIso8601String(),
      'type': type.name,
      'value': value,
    };
  }

  factory MoneyType.fromMap(Map<String, dynamic> map) {
    return MoneyType(
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      type: ValueType.values.byName(map['type'] as String),
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyType.fromJson(String source) => MoneyType.fromMap(json.decode(source) as Map<String, dynamic>);
}
