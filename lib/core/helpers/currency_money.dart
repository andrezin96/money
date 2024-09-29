import 'currency_text_input_formatter.dart';

class CurrencyMoney {
  static const String _customPattern = '\u00a4 #,##0.00';

  static String print(num? value) {
    return CurrencyTextInputFormatter(
      customPattern: _customPattern,
      locale: 'pt_BR',
      symbol: r'R$',
    ).format(value?.toStringAsFixed(2) ?? '');
  }

  static String initial(num? value) {
    return CurrencyTextInputFormatter(
      customPattern: _customPattern,
      locale: 'pt_BR',
    ).format(value?.toStringAsFixed(2) ?? '');
  }

  static CurrencyTextInputFormatter get formatter {
    return CurrencyTextInputFormatter(
      customPattern: _customPattern,
      locale: 'pt_BR',
    );
  }

  static String original(String value) {
    return CurrencyTextInputFormatter().format(value);
  }
}

extension CurrencyMoneyExtension on double {
  String get toCurrency => CurrencyMoney.print(this);
  String get toCurrencyInitial => CurrencyMoney.initial(this);
}

extension CurrencyStringExtension on String {
  double get toCurrencyOriginal => double.tryParse(CurrencyMoney.original(this).replaceAll(',', '.')) ?? 0.0;
}
