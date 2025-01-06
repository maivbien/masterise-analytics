extension StringAnalytics on String {
  String get fullTrim => replaceAll(RegExp(r'\s+'), ' ').trim();

  String limitChars(int limit) {
    final output = trim();
    if (output.length <= limit) {
      return output;
    }
    return output.substring(0, limit);
  }
}

bool isNullOrEmpty(Object? data) {
  if (data == null) return true;

  if (data is String) {
    return data.trimLeft().isEmpty;
  } else if (data is Iterable) {
    return data.isEmpty;
  } else if (data is Map) {
    return data.isEmpty;
  }
  return false;
}

bool isNotNullOrEmpty(Object? data) => !isNullOrEmpty(data);
