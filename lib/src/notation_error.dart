part of cube;

/**
 * An error parsing notation.
 */
class NotationError extends Error {
  final String message;
  
  NotationError(this.message);
  
  String toString() => 'NotationError: $message';
}