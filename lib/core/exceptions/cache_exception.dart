class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

class StorageException implements Exception {
  final String message;

  StorageException([this.message = 'Storage error occurred']);

  @override
  String toString() => 'StorageException: $message';
}
