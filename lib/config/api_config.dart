
class ApiConfig {
  static const String baseUrl =
      'http://localhost:8080/api-test/public';

  static const Duration timeout = Duration(seconds: 30);

  static Uri uri(String chemin) {
    return Uri.parse('$baseUrl$chemin');
  }
}
