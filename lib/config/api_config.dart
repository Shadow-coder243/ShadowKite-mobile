class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.shadowkite.com/api',
  );

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String meEndpoint = '/auth/me';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String profileEndpoint = '/profile';
  static const String cvEndpoint = '/cv';
  static const String portfolioEndpoint = '/portfolio';

  static Uri getUri(String path) {
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath');
  }
}
