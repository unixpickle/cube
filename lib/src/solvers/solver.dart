part of cube;

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

/**
 * An abstract base class which must be subclassed in order to synchronously
 * solve a cube state. The term "solve" is completely abstracted by class
 * methods which you must override. Additionally, you must implement your own
 * lower-bound heuristic.
 */
abstract class Solver<S extends CubeState> {
  /**
   * The maximum depth this solver may reach.
   */
  final int maxDepth;
  
  /**
   * The algorithm prefix. Usually, an empty algorithm.
   */
  final Algorithm startAlgo;
  
  /**
   * The moves which this solver applies to explore neighboring states of a
   * state.
   */
  final List<Move<S>> basis;
  
  /**
   * The state at which this search began.
   */
  final S start;
  
  int _depth;
  bool _paused;
  final List<_SolverNode<S>> _nodes;
  
  /**
   * Create a new solver that starts at the state [start] and uses moves from
   * [basis] to explore neighboring states.
   * 
   * You should specify [maxDepth] to indicate the maximum depth that the seacrh
   * may reach before giving up.
   * 
   * The [startAlgo] argument is necessary because the type of [start] is
   * abstract. Usually, you would pass in an empty algorithm.
   */
  Solver(this.start, this.basis, this.maxDepth, this.startAlgo) : _nodes = [] {
    _depth = 0;
    _restart();
  }
  
  /**
   * Run the solver.
   */
  void run() {
    _paused = false;
    while (_depth <= maxDepth) {
      while (_nodes.length != 0) {
        if (_paused) return;
        _SolverNode<S> node = _nodes.last;
        _nodes.removeLast();
        if (node.depth == _depth) {
          handleState(node.state, node.algorithm);
        } else {
          if (heuristic(node.state) > _depth - node.depth) {
            continue;
          }
          _nodes.addAll(node.expand(basis));
        }
      }
      if (_paused) return;
      ++_depth;
      _restart();
    }
  }
  
  /**
   * Implement this to receive every base node that gets reached.
   */
  void handleState(S s, Algorithm<S> a);
  
  /**
   * Implement this to act as a simple lower-bound heuristic.
   */
  int heuristic(S s);
  
  /**
   * Cancel a solve so that [run] returns. You may resume by running [run]
   * again.
   */
  void pause() {
    _paused = true;
  }
  
  void _restart() {
    _nodes.add(new _SolverNode<S>(0, start, startAlgo));
  }
}
