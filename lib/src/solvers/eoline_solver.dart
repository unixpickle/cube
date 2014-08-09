part of cube;

/**
 * Solve the EO line optimally on a 3x3x3.
 */
class EOLineSolver<S extends CubeState> extends AsyncSolver<S> {
  final EOLineHeuristics heuristics;
  
  /**
   * Create an [EOLineSolver] from a set of standard information and a set of
   * pre-loaded indexes [heuristics].
   */
  EOLineSolver(S start, List<Move<S>> basis, Algorithm<S> startAlg,
      this.heuristics, {int aMaxDepth: 9}) :
          super(start, basis, aMaxDepth, startAlg);
  
  /**
   * Heuristic function for the EO line.
   */
  int heuristic(S s) {
    return heuristics.moveCount(s.edges);
  }
  
  /**
   * Checks if a state has the EOLine solved.
   */
  bool isSolved(S state) {
    Edges edges = state.edges;
    if (!edges.orientationsForAxis(2).every((x) => x == true)) {
      return false;
    }
    if (edges.readEdge(2, 0) != 2) return false;
    if (edges.readEdge(8, 0) != 8) return false;
    return true;
  }
}
