class Strings {
  static String capitalize(String s) {
    assert(s != null);
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }
}
