class ServerException implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  String toString() => message ?? 'ServerException';
}

class AuthException implements Exception {
  final String? message;

  const AuthException([this.message]);

  @override
  String toString() => message ?? 'AuthException';
}
