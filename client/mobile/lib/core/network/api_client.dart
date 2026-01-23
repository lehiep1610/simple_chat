import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  String? _authToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  Uri _buildUri(String path, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    if (queryParams != null) {
      return uri.replace(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _client.get(
        _buildUri(path, queryParameters),
        headers: _headers,
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.post(
        _buildUri(path),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.put(
        _buildUri(path),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _client.delete(_buildUri(path), headers: _headers);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
    } on FormatException {
      throw ServerException(
        message:
            'Invalid response from server: ${response.body.substring(0, 100)}',
        statusCode: response.statusCode,
      );
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 401:
        throw UnauthorizedException(message: body['message'] ?? 'Unauthorized');
      case 400:
      case 404:
      case 500:
      default:
        throw ServerException(
          message: body['message'] ?? 'Server error',
          statusCode: response.statusCode,
        );
    }
  }

  void dispose() {
    _client.close();
  }
}
