part of cube;

/**
 * A solver which tunnels solutions through a stream. This class uses a timer
 * to periodically resign control to your application, making it perfect for
 * solving on the web.
 */
abstract class AsyncSolver<S extends CubeState> extends Solver<S> {
  StreamController<Algorithm<S>> _controller;
  DateTime _startTime;
  
  /**
   * A stream which sends solutions.
   */
  Stream<Algorithm<S>> get stream => _controller.stream;
  
  /**
   * Create an [AsyncSolver] from a state [start], a basis [basis], a maximum
   * depth [maxDepth], and a prefix algorithm [startAlg].
   */
  AsyncSolver(S start, List<Move<S>> basis, int maxDepth,
      Algorithm<S> startAlg) : super(start, basis, maxDepth, startAlg) {
    _controller = new StreamController(onListen: _onListen, onPause: _onPause,
        onCancel: _onCancel, onResume: _onResume, sync: true);
  }
  
  /**
   * Do not call this directly. Instead, pause your subscription to [stream].
   */
  void pause() {
    throw new UnsupportedError('pause an AsyncSolver through' +
        'your stream subscription');
  }
  
  /**
   * Sends an algorithm over the stream if its state is solved. You should not
   * call this directly.
   */
  void handleState(S s, Algorithm<S> a) {
    if (isSolved(s)) {
      _controller.add(a);
    }
    _pauseIfNeeded();
  }
  
  /**
   * Implement this to verify that a state should be sent over the output
   * stream.
   */
  bool isSolved(S s);
  
  void _onListen() {
    scheduleMicrotask(_startTimer);
  }
  
  void _onPause() {
    super.pause();
  }
  
  void _onCancel() {
    super.pause();
    _controller.close();
  }
  
  void _onResume() {
    _onListen();
  }
  
  void _pauseIfNeeded() {
    int millis = new DateTime.now().difference(_startTime).inMilliseconds;
    if (millis >= 10) {
      super.pause();
      new Future.value().then((_) => _startTimer());
    }
  }
  
  void _startTimer() {
    if (_controller.isPaused || _controller.isClosed) {
      return;
    }
    _startTime = new DateTime.now();
    run();
  }
}
