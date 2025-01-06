import 'package:easy_localization/easy_localization.dart';

import '../../../config/constants/app_constant.dart';
import '../../../config/localization/app_localization.dart';
import '../../../di.dart';

extension StringX on String {
  String translate({
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    return injector
        .get<AppLocalization>()
        .translate(this, args: args, gender: gender, namedArgs: namedArgs);
  }

  String get fullTrim => replaceAll(RegExp(r'\s+'), ' ').trim();

  double? get toDoubleOrNull {
    try {
      return isEmpty
          ? null
          : NumberFormat.currency(
                  decimalDigits: 0,
                  locale:
                      '${AppConstant.localeVi.languageCode}_${AppConstant.localeVi.countryCode}',
                  symbol: '')
              .parse(this)
              .toDouble();
    } catch (_) {
      return null;
    }
  }

  double get toDouble => toDoubleOrNull ?? 0.0;

  String limitChars(int limit) {
    final output = trim();
    if (output.length <= limit) {
      return output;
    }
    return output.substring(0, limit);
  }
}
