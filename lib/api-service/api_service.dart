import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
    baseUrl: 'http://50.62.183.116:301/rough-entry/', // Set common baseUrl here
    headers: {
      'content-type': 'application/json',
    },
  ));

  Future<List<T>?> fetchData<T>({
    required String endpoint, // Only endpoint is required now
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(endpoint); // Use endpoint here

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        // Mapping and storing in descending order
        return data.map(fromJson).toList().reversed.toList();
      } else {
        throw Exception('Failed to load data for $endpoint: ${response.statusMessage}');
      }
    } catch (error) {
      // Log and return null in case of error
      if (kDebugMode) {
        print('Error fetching data from $endpoint: $error');
      }
      return null;
    }
  }
}
