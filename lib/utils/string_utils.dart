class StringUtils {
  static String formatString(String? value, {int? length}) {
    if (value == null) return '';
    length ??= 14;
    if (value.length > length) {
      return "${value.substring(0, length)}...";
    }
    return value;
  }
}
