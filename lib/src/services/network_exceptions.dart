import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@immutable
sealed class NetworkException {}

final class RequestCancelled extends NetworkException {}

final class BadCertificate extends NetworkException {}

/// [response] is the data that is returned by
/// the API when the request has failed.
final class BadResponse extends NetworkException {
  BadResponse(this.response);
  final Response<dynamic>? response;
}

final class Unknown extends NetworkException {}

final class ConnectionTimeout extends NetworkException {}

final class NoInternetConnection extends NetworkException {}

final class UnableToFormat extends NetworkException {}

final class UnableToProcess extends NetworkException {}

/// Catches all different types of errors and converts
/// them into a simplified [NetworkException] object
/// for easier handling.
NetworkException getNetworkException(Object? error) {
  if (error is Exception) {
    try {
      if (error is DioException) {
        return switch (error.type) {
          DioExceptionType.connectionTimeout => ConnectionTimeout(),
          DioExceptionType.sendTimeout => ConnectionTimeout(),
          DioExceptionType.receiveTimeout => ConnectionTimeout(),
          DioExceptionType.badCertificate => BadCertificate(),
          DioExceptionType.badResponse => BadResponse(error.response),
          DioExceptionType.cancel => RequestCancelled(),
          DioExceptionType.connectionError => NoInternetConnection(),
          DioExceptionType.unknown => Unknown(),
        };
      }

      if (error is SocketException) {
        return NoInternetConnection();
      }

      return Unknown();
    } on FormatException catch (_) {
      return UnableToFormat();
    }
  }

  if (error.toString().contains('is not a subtype of')) {
    return UnableToProcess();
  }

  return Unknown();
}

/// Helper class for generating error messages based on the exceptions
/// that have been caught for each network request.
///
/// If the API call has succeeded but returns an error response,
/// displays [badResponseMessage] if it is provided.
/// Else, display the default status message that is provided by Dio.
String getNetworkErrorMessage(
  Object? exception, {
  String? Function(dynamic)? badResponseMessage,
}) {
  /// Log error
  log(exception.toString());

  /// Return error message based on exception type
  final networkException = getNetworkException(exception);
  return switch (networkException) {
    RequestCancelled() => 'The request was cancelled.',
    BadCertificate() => 'Bad certificate error.',
    BadResponse(response: final response) => badResponseMessage != null
        ? badResponseMessage(response?.data) ?? ''
        // ignore: avoid_dynamic_calls
        : getBadResponseMessage(response),
    Unknown() => 'There has been an unknown error. Please try again later.',
    ConnectionTimeout() => 'The request took longer than expected. Please try again later.',
    NoInternetConnection() => 'Failed to connect to the internet. Please check your internet connectivity and try again later.',
    UnableToFormat() => 'Unable to format the data. Please try again later.',
    UnableToProcess() => 'Unable to process the data. Please try again later.',
  };
}

String getBadResponseMessage(Response<dynamic>? response) {
  // ignore: avoid_dynamic_calls
  if(response?.data?['userMessage'].toString() != 'null' && response?.data?['userMessage'].toString() != 'undefined'){
    // ignore: avoid_dynamic_calls
    return response!.data['userMessage'].toString();
  }

  return response?.statusMessage ?? '';
}
