import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shadowkite_mobile/services/api_service.dart';
import 'package:shadowkite_mobile/services/token_storage_service.dart';

class MockClient extends http.BaseClient {
  http.Request? lastRequest;
  int statusCode = 200;
  String responseBody = '{}';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request is http.Request) {
      lastRequest = request;
    }
    final stream = Stream.value(utf8.encode(responseBody));
    return http.StreamedResponse(stream, statusCode);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockClient mockClient;
  late TokenStorageService tokenStorageService;
  late ApiService apiService;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    mockClient = MockClient();
    tokenStorageService = TokenStorageService(storage: const FlutterSecureStorage());
    apiService = ApiService(client: mockClient, tokenStorage: tokenStorageService);
  });

  test('adds Authorization header when token exists and requiresAuth is true', () async {
    await tokenStorageService.saveTokens(accessToken: 'my_secret_token');
    mockClient.responseBody = jsonEncode({'data': 'success'});

    final result = await apiService.get('/profile', requiresAuth: true);

    expect(result, {'data': 'success'});
    expect(mockClient.lastRequest, isNotNull);
    expect(mockClient.lastRequest!.headers['Authorization'], 'Bearer my_secret_token');
  });

  test('login saves token and sends credentials', () async {
    mockClient.responseBody = jsonEncode({'token': 'auth_token_abc'});

    final result = await apiService.login('user@example.com', 'password123');

    expect(result['token'], 'auth_token_abc');
    expect(await tokenStorageService.getAccessToken(), 'auth_token_abc');
    expect(mockClient.lastRequest!.body, jsonEncode({
      'email': 'user@example.com',
      'password': 'password123',
    }));
  });

  test('handles 401 Unauthorized by clearing token and throwing ApiException', () async {
    await tokenStorageService.saveTokens(accessToken: 'expired_token');
    mockClient.statusCode = 401;
    mockClient.responseBody = jsonEncode({'message': 'Unauthorized'});

    expect(
      () => apiService.get('/profile'),
      throwsA(isA<ApiException>()),
    );

    // Wait for async handling
    await Future<void>.delayed(Duration.zero);
    expect(await tokenStorageService.hasToken(), false);
  });
}
