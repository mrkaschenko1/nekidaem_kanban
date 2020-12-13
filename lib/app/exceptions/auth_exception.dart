class AuthException implements Exception {
  String _message;

  AuthException([String message = 'Authentication exception']) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
