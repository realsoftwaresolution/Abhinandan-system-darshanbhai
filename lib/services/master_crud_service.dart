import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/services/api_service.dart';

/// Reusable generic CRUD service engine for ERP master entities.
class MasterCrudService {
  final ApiService _api = ApiService.to;

  /// Generic fetch list supporting optional company code query param
  Future<List<T>?> fetchList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    int? companyCode,
    String errorContext = 'fetch list',
    bool reverse = false,
  }) async {
    try {
      final String query = (companyCode != null && companyCode != 0)
          ? '?CompanyCode=$companyCode'
          : '';
      final response = await _api.get('$endpoint$query');

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = [];
        if (response.data is List) {
          data = response.data as List<dynamic>;
        } else if (response.data is Map && response.data['data'] is List) {
          data = response.data['data'] as List<dynamic>;
        }

        final list = data
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();

        return reverse ? list.reversed.toList() : list;
      } else {
        errorDialog(
            messageText: 'Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.$errorContext');
      if (kDebugMode) {
        log('$errorContext error: $error');
      }
    }
    return null;
  }

  /// Generic fetch single record by ID
  Future<T?> fetchById<T>({
    required String endpoint,
    dynamic id,
    required T Function(Map<String, dynamic> json) fromJson,
    String? errorContext,
  }) async {
    try {
      final url = id != null ? '$endpoint/$id' : endpoint;
      final response = await _api.get(url);
      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        if (raw is List && raw.isNotEmpty && raw.first is Map) {
          return fromJson(raw.first as Map<String, dynamic>);
        } else if (raw is Map<String, dynamic> &&
            raw['data'] != null &&
            raw['data'] is Map<String, dynamic>) {
          return fromJson(raw['data'] as Map<String, dynamic>);
        } else if (raw is Map<String, dynamic> &&
            raw['data'] != null &&
            raw['data'] is List &&
            (raw['data'] as List).isNotEmpty &&
            (raw['data'] as List).first is Map) {
          return fromJson((raw['data'] as List).first as Map<String, dynamic>);
        } else if (raw is Map<String, dynamic>) {
          return fromJson(raw);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        log('fetchById error ($endpoint): $error');
      }
    }
    return null;
  }

  /// Generic fetch next code or sort ID
  Future<Map<String, dynamic>?> fetchNextCode({
    required String endpoint,
    String? errorContext,
  }) async {
    try {
      final response = await _api.get(endpoint);
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        log('fetchNextCode error ($endpoint): $error');
      }
    }
    return null;
  }

  /// Generic create (POST)
  Future<bool> create({
    required String endpoint,
    required Map<String, dynamic> payload,
    Future<void> Function()? onSuccess,
    String? defaultSuccessMsg,
    String defaultSuccessMessage = 'Entry Saved Successfully',
    RxBool? isLoading,
    RxBool? loadingState,
    String? errorContext,
  }) async {
    final loader = isLoading ?? loadingState;
    final successMsg = defaultSuccessMsg ?? defaultSuccessMessage;
    try {
      loader?.value = true;
      final response = await _api.post(endpoint, data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : successMsg;
        successDialog(messageText: msg);
        if (onSuccess != null) {
          await onSuccess();
        }
        loader?.value = false;
        return true;
      } else {
        errorDialog(
            messageText: 'Failed to Save Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('create error ($endpoint): $error');
      }
    } finally {
      loader?.value = false;
    }
    return false;
  }

  /// Generic update (PUT)
  Future<bool> update({
    required String endpoint,
    dynamic id,
    required Map<String, dynamic> payload,
    Future<void> Function()? onSuccess,
    String? defaultSuccessMsg,
    String defaultSuccessMessage = 'Entry Updated Successfully',
    RxBool? isLoading,
    RxBool? loadingState,
    String? errorContext,
  }) async {
    final loader = isLoading ?? loadingState;
    final successMsg = defaultSuccessMsg ?? defaultSuccessMessage;
    try {
      loader?.value = true;
      final url = id != null ? '$endpoint/$id' : endpoint;
      final response = await _api.put(url, data: payload);
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          await onSuccess();
        }
        loader?.value = false;
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : successMsg;
        successDialog(messageText: msg);
        return true;
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('update error ($endpoint): $error');
      }
    } finally {
      loader?.value = false;
    }
    return false;
  }

  /// Generic delete (DELETE)
  Future<bool> delete({
    required String endpoint,
    dynamic id,
    Future<void> Function()? onSuccess,
    String? defaultSuccessMsg,
    String defaultSuccessMessage = 'Entry Deleted Successfully',
    RxBool? isDeleteLoading,
    RxBool? deleteLoadingState,
    String? errorContext,
  }) async {
    final loader = isDeleteLoading ?? deleteLoadingState;
    final successMsg = defaultSuccessMsg ?? defaultSuccessMessage;
    try {
      loader?.value = true;
      final url = id != null ? '$endpoint/$id' : endpoint;
      final response = await _api.delete(url);
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          await onSuccess();
        }
        loader?.value = false;
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : successMsg;
        successDialog(messageText: msg);
        return true;
      } else {
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('delete error ($endpoint): $error');
      }
    } finally {
      loader?.value = false;
    }
    return false;
  }
}
