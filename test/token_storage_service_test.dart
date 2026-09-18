import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadowkite_mobile/services/token_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorageService tokenStorageService;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    tokenStorageService = TokenStorageService(storage: const FlutterSecureStorage());
  });

  test('saveTokens and getAccessToken returns stored token', () async {
    expect(await tokenStorageService.hasToken(), false);

    await tokenStorageService.saveTokens(
      accessToken: 'test_jwt_access_token',
      refreshToken: 'test_jwt_refresh_token',
    );

    expect(await tokenStorageService.hasToken(), true);
    expect(await tokenStorageService.getAccessToken(), 'test_jwt_access_token');
    expect(await tokenStorageService.getRefreshToken(), 'test_jwt_refresh_token');
  });

  test('clearTokens removes stored tokens', () async {
    await tokenStorageService.saveTokens(
      accessToken: 'test_jwt_access_token',
      refreshToken: 'test_jwt_refresh_token',
    );

    await tokenStorageService.clearTokens();

    expect(await tokenStorageService.hasToken(), false);
    expect(await tokenStorageService.getAccessToken(), null);
    expect(await tokenStorageService.getRefreshToken(), null);
  });
}
