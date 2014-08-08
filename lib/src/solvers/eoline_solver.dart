part of cube;

/**
 * Solve the EO line optimally on a 3x3x3.
 */
class EOLineSolver<S extends CubeState> extends AsyncSolver<S> {
  EOLineSolver(S start, Algorithm<S> startAlgo, List<Move<S>> basis,
      {int aMaxDepth: 9}) :
      super(_eoChecker, start, _eoHeuristic, basis, aMaxDepth, startAlgo) {
  }
  
  static int _eoHeuristic(CubeState aState) {
    Heuristic3x3x3 heuristic = new Heuristic3x3x3(aState.edges);
    return heuristic.eoLineFrontEdgeMoveCount();
    /*return max(heuristic.edgeOrientationMoveCount(2),
        heuristic.eoLineEdgeMoveCount());*/
  }
  
  static bool _eoChecker(CubeState state) {
    Edges edges = state.edges;
    if (!edges.orientationsForAxis(2).every((x) => x == true)) {
      return false;
    }
    if (edges.readEdge(2, 0) != 2) return false;
    if (edges.readEdge(8, 0) != 8) return false;
    return true;
  }
}
