part of cube;

typedef int SolveHeuristic(CubeState state);
typedef void SolveCallback(CubeState state, Algorithm algo);

class _SolverNode<S extends CubeState> {
  final int depth;
  final S state;
  final Algorithm<S> algorithm;
  
  _SolverNode(this.depth, this.state, this.algorithm);
  
  List<_SolverNode<S>> expand(List<Move<S>> basis) {
    List<_SolverNode<S>> result = new List<_SolverNode>(basis.length);
    for (int i = 0; i < basis.length; ++i) {
      S newState = basis[i].permutation.applyToState(state);
      Algorithm<S> newAlgo = algorithm + basis[i];
      result[i] = new _SolverNode<S>(depth + 1, newState, newAlgo);
    }
    return result;
  }
}

class Solver<S extends CubeState> {
  final int maxDepth;
  int depth;
  final Algorithm startAlgo;
  final List<Move<S>> basis;
  final List<_SolverNode<S>> nodes;
  final SolveHeuristic heuristic;
  final SolveCallback callback;
  final S start;
  
  bool _paused;
  
  Solver(this.start, this.basis, this.maxDepth, this.callback,
         this.heuristic, this.startAlgo) : nodes = [] {
    depth = 0;
    _restart();
  }
  
  void run() {
    _paused = false;
    while (depth <= maxDepth) {
      while (nodes.length != 0) {
        if (_paused) return;
        _SolverNode node = nodes.last;
        nodes.removeLast();
        if (node.depth == depth) {
          callback(node.state, node.algorithm);
        } else {
          if (heuristic(node.state) > depth - node.depth) {
            continue;
          }
          nodes.addAll(node.expand(basis));
        }
      }
      if (_paused) return;
      ++depth;
      _restart();
    }
  }
  
  void pause() {
    _paused = true;
  }
  
  void _restart() {
    nodes.add(new _SolverNode<S>(0, start, startAlgo));
  }
}
