// ============================================================
// FILE: lib/shared/models/api_response.dart
// PURPOSE: Generic wrapper for all API responses.
//          Server always returns:
//          { "success": bool, "data": T, "message": string }
//
// Usage:
//   final res = ApiResponse.fromJson(json, (j) => UserModel.fromJson(j));
// ============================================================

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}
