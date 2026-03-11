/// Exception thrown when the remote server returns a non-success status code.
class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'A server error occurred.'});
}

/// Exception thrown when there is no internet connectivity.
class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection.'});
}

/// Exception thrown when local cache operations fail.
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'A cache error occurred.'});
}
