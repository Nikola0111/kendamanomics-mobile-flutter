import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';

class DioService with LoggerMixin {
  late Dio _dio;

  DioService() {
    final base =
        Uri(host: EnvironmentService.host, scheme: EnvironmentService.scheme, port: EnvironmentService.port).toString();

    final options = BaseOptions(baseUrl: base, headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    });
    _dio = Dio(options);
    logI('baseUrl: ${_dio.options.baseUrl}');
  }

  Future<dynamic> get(
    String path, {
    Map<String, String> headers = const {},
    Map<String, dynamic>? query,
  }) async {
    try {
      final responseData = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: await getHeaders(headers)),
      );
      return responseData.data;
    } on SocketException catch (e) {
      logE('socket exception ${e.toString()}');
    }
  }

  Future<dynamic> put(
    String path,
    Map<String, dynamic> body, {
    Map<String, String> headers = const {},
    Map<String, String>? query,
    bool withHeaders = false,
  }) async {
    try {
      final responseData = await _dio.put(
        path,
        data: body,
        options: Options(headers: await getHeaders(headers)),
      );
      return responseData.data;
    } on SocketException {
      logE('socket exception');
    }
  }

  Future<dynamic> post(
    String path,
    Map<String, dynamic> map, {
    Map<String, String> headers = const {},
    Map<String, String>? query,
    bool withHeaders = false,
  }) async {
    try {
      final responseData = await _dio.post(
        path,
        data: map,
        options: Options(headers: await getHeaders(headers)),
      );
      return responseData.data;
    } on SocketException catch (e) {
      logE('socket exception ${e.toString()}');
    }
  }

  Future<dynamic> patch(
    String path,
    Map<String, dynamic> map, {
    Map<String, String> headers = const {},
    Map<String, String>? query,
    bool withHeaders = false,
  }) async {
    try {
      final responseData = await _dio.patch(
        path,
        data: map,
        options: Options(headers: await getHeaders(headers)),
      );
      return responseData.data;
    } on SocketException {
      logE('socket exception');
    }
  }

  Future<dynamic> delete(
    String path, {
    Map<String, String> headers = const {},
    bool withHeaders = false,
  }) async {
    try {
      final responseData = await _dio.delete(
        path,
        options: Options(headers: await getHeaders(headers)),
      );
      return responseData.data;
    } on SocketException {
      logE('socket exception');
    }
  }

  Future<Map<String, String>> getHeaders(
    Map<String, String> extraHeaders,
  ) async {
    Map<String, String> headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
      ...extraHeaders,
    };

    // TODO: check how to get token, sharedprefs maybe?
    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    // if (token != null) {
    //   headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    // }
    return headers;
  }

  @override
  String get className => 'DioService';
}
