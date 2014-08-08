part of cube;

typedef bool SolveChecker(CubeState state);

class AsyncSolver<S extends CubeState> {
  final SolveChecker _checker;
  final SolveHeuristic _heuristicCb;
  Solver<S> _solver;
  StreamController<Algorithm<S>> _controller;
  DateTime _startTime;
  
  Stream<Algorithm<S>> get stream => _controller.stream;
  
  AsyncSolver(this._checker, S start, this._heuristicCb,
      List<Move<S>> basis, int maxDepth, Algorithm<S> empty) {
    _solver = new Solver(start, basis, maxDepth, _solveCallback,
        _heuristic, empty);
    _controller = new StreamController(onListen: _onListen, onPause: _onPause,
        onCancel: _onCancel, onResume: _onResume);
  }
  
  void _solveCallback(CubeState state, Algorithm solution) {
    assert(state is S);
    assert(solution is Algorithm<S>);
    if (_checker(state)) {
      _controller.add(solution);
    }
    _pauseIfNeeded();
  }
  
  int _heuristic(CubeState state) {
    assert(state is S);
    int res = _heuristicCb(state);
    return res;
  }
  
  void _onListen() {
    scheduleMicrotask(_startTimer);
  }
  
  void _onPause() {
    _solver.pause();
  }
  
  void _onCancel() {
    _solver.pause();
    _controller.close();
  }
  
  void _onResume() {
    _onListen();
  }
  
  void _pauseIfNeeded() {
    int millis = new DateTime.now().difference(_startTime).inMilliseconds;
    if (millis >= 10) {
      _solver.pause();
      new Future.value().then((_) => _startTimer());
    }
  }
  
  void _startTimer() {
    if (_controller.isPaused || _controller.isClosed) {
      return;
    }
    _startTime = new DateTime.now();
    _solver.run();
  }
}
