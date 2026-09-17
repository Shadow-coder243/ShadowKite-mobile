import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_storage_service.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class ApiService {
  ApiService({
    http.Client? client,
    TokenStorageService? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorageService();

  final http.Client _client;
  final TokenStorageService _tokenStorage;

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    final uri = ApiConfig.getUri(endpoint);
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = ApiConfig.getUri(endpoint);
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final response = await _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = ApiConfig.getUri(endpoint);
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final response = await _client.put(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    final uri = ApiConfig.getUri(endpoint);
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final response = await _client.delete(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final responseData = await post(
      ApiConfig.loginEndpoint,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    if (responseData is Map<String, dynamic>) {
      final accessToken = responseData['token'] ?? responseData['access_token'];
      final refreshToken = responseData['refresh_token'];
      if (accessToken is String) {
        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken is String ? refreshToken : null,
        );
      }
    }

    return responseData is Map<String, dynamic> ? responseData : {};
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final responseData = await post(
      ApiConfig.registerEndpoint,
      body: {'name': name, 'email': email, 'password': password},
      requiresAuth: false,
    );

    if (responseData is Map<String, dynamic>) {
      final accessToken = responseData['token'] ?? responseData['access_token'];
      final refreshToken = responseData['refresh_token'];
      if (accessToken is String) {
        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken is String ? refreshToken : null,
        );
      }
    }

    return responseData is Map<String, dynamic> ? responseData : {};
  }

  Future<void> logout() async {
    try {
      await post('/auth/logout', requiresAuth: true);
    } catch (_) {
      // Ignore network failure on logout
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final data = await get(ApiConfig.meEndpoint, requiresAuth: true);
    return data is Map<String, dynamic> ? data : {};
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      _tokenStorage.clearTokens();
      throw ApiException('Session expirée ou non autorisée', statusCode: 401);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    }

    String errorMessage = 'Erreur serveur (${response.statusCode})';
    try {
      final bodyMap = jsonDecode(response.body);
      if (bodyMap is Map && bodyMap.containsKey('message')) {
        errorMessage = bodyMap['message'].toString();
      }
    } catch (_) {}

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }
}
