import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum ValueType {
  credit,
  debit,
  none,
}

class BudgetModel {
  const BudgetModel({
    required this.description,
    required this.type,
    required this.values,
    required this.creditsTotal,
    required this.debitsTotal,
    required this.total,
  });
  final String description;
  final ValueType type;
  final List<MoneyType> values;
  final double creditsTotal;
  final double debitsTotal;
  final double total;

  BudgetModel copyWith({
    String? description,
    ValueType? type,
    List<MoneyType>? values,
    List<MoneyType>? debits,
    double? creditsTotal,
    double? debitsTotal,
    double? total,
  }) {
    return BudgetModel(
      description: description ?? this.description,
      type: type ?? this.type,
      values: values ?? this.values,
      creditsTotal: creditsTotal ?? this.creditsTotal,
      debitsTotal: debitsTotal ?? this.debitsTotal,
      total: total ?? this.total,
    );
  }

  factory BudgetModel.empty() {
    return const BudgetModel(
      description: '',
      type: ValueType.none,
      values: [],
      creditsTotal: 0,
      debitsTotal: 0,
      total: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'type': type.name,
      'values': values.map((value) => value.toMap()).toList(),
      'creditsTotal': creditsTotal,
      'debitsTotal': debitsTotal,
      'total': total,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      description: map['description'] as String,
      type: ValueType.values.byName(map['type'] as String),
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
    required this.value,
  });
  final String description;
  final double value;

  MoneyType copyWith({
    String? description,
    double? value,
  }) {
    return MoneyType(
      description: description ?? '',
      value: value ?? 0,
    );
  }

  factory MoneyType.empty() {
    return const MoneyType(
      description: '',
      value: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'value': value,
    };
  }

  factory MoneyType.fromMap(Map<String, dynamic> map) {
    return MoneyType(
      description: map['description'] as String,
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyType.fromJson(String source) => MoneyType.fromMap(json.decode(source) as Map<String, dynamic>);
}