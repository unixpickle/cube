part of cube;

class NotationError extends Error {
  final String message;
  
  NotationError(this.message);
  
  String toString() => 'NotationError: $message';
}