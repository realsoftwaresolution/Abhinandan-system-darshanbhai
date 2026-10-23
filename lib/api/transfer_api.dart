import 'dart:convert';
import 'package:http/http.dart' as http;

/// A generic Transfer API client used for both BranchTransfer and
/// InternalStockTransfer endpoints.
///
/// The constructor receives the base URL (including the API prefix).
/// Example:
///   final branchApi = TransferApi(baseUrl: 'https://api.myapp.com/branch-transfer');
///   final internalApi = TransferApi(baseUrl: 'https://api.myapp.com/internal-stock-transfer');
class TransferApi {
  final String baseUrl;

  TransferApi({required this.baseUrl});

  /// Helper to process the HTTP response. Throws an [Exception] on non‑200.
  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      return jsonDecode(response.body);
    }
    // Try to decode the error body for a nicer message.
    try {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'API error ($status)');
    } catch (_) {
      throw Exception('API error ($status)');
    }
  }

  // ---------------------------------------------------------------------
  // Combined data (uses the shared validation schema on the back‑end)
  // ---------------------------------------------------------------------
  Future<dynamic> getCombined({required int companyCode, required int fromCrId}) async {
    final uri = Uri.parse('$baseUrl/combined')
        .replace(queryParameters: {'companyCode': '$companyCode', 'fromCrId': '$fromCrId'});
    final response = await http.get(uri);
    return _handleResponse(response);
  }

  // ---------------------------------------------------------------------
  // CRUD – master table
  // ---------------------------------------------------------------------
  Future<dynamic> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    return _handleResponse(response);
  }

  Future<dynamic> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    return _handleResponse(response);
  }

  Future<dynamic> save(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse('$baseUrl/save'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return _handleResponse(response);
  }

  Future<dynamic> update(String id, Map<String, dynamic> payload) async {
    final response = await http.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return _handleResponse(response);
  }

  // ---------------------------------------------------------------------
  // Pending / confirm flow
  // ---------------------------------------------------------------------
  Future<dynamic> getPendingDetails(String managerId) async {
    final response = await http.get(Uri.parse('$baseUrl/pending/$managerId'));
    return _handleResponse(response);
  }

  Future<dynamic> confirm(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse('$baseUrl/confirm'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return _handleResponse(response);
  }

  Future<dynamic> getAllConfirmMsts() async {
    final response = await http.get(Uri.parse('$baseUrl/confirm/list'));
    return _handleResponse(response);
  }

  // ---------------------------------------------------------------------
  // Detail endpoints (non‑confirmed & confirmed)
  // ---------------------------------------------------------------------
  Future<dynamic> getAllDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/details'));
    return _handleResponse(response);
  }

  Future<dynamic> getDetailsByToCrId(String toCrId) async {
    final response = await http.get(Uri.parse('$baseUrl/details/$toCrId'));
    return _handleResponse(response);
  }

  Future<dynamic> getDetailsByConfirmMstId(String confirmMstId) async {
    final response = await http.get(Uri.parse('$baseUrl/confirm/details/$confirmMstId'));
    return _handleResponse(response);
  }
}

/// Ready‑to‑use instances for the two modules.
/// Adjust the base URLs to match your dev / production environment.
final branchTransferApi = TransferApi(baseUrl: 'http://localhost:8080/branch-transfer');
final internalStockTransferApi = TransferApi(baseUrl: 'http://localhost:8080/internal-stock-transfer');
