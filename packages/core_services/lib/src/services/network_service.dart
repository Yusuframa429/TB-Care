import 'dart:convert';
import 'package:http/http.dart' as http;
import '../architecture/exceptions.dart';
import 'logger_service.dart';

/// [NetworkService] - Client HTTP sederhana dengan penanganan error.
class NetworkService {
  final http.Client _client;

  NetworkService({http.Client? client}) : _client = client ?? http.Client();

  /// Melakukan request GET.
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      LoggerService.i('GET Request to: $url');
      final response = await _client.get(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      LoggerService.e('GET Error: $e');
      throw const ServerException('Gagal terhubung ke server.');
    }
  }

  /// Melakukan request POST.
  Future<dynamic> post(String url, {Map<String, String>? headers, Object? body}) async {
    try {
      LoggerService.i('POST Request to: $url');
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      LoggerService.e('POST Error: $e');
      throw const ServerException('Gagal terhubung ke server.');
    }
  }

  /// Menangani HTTP Response.
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      LoggerService.e('HTTP Error $statusCode: ${response.body}');
      throw ServerException('Request gagal dengan status: $statusCode');
    }
  }
}
