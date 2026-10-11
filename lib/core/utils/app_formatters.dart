// Implements Figma monetary and date formatting foundations.
import 'package:intl/intl.dart';

abstract final class AppFormatters {
  static final _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String inr(num amount) => _inr.format(amount);

  static String date(DateTime value, {required String pattern}) =>
      DateFormat(pattern, 'en_IN').format(value);
}
