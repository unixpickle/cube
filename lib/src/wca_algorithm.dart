part of cube;

/**
 * An algorithm is simply an ordered list of moves. A [WcaAlgorithm] represents
 * a chain of [WcaMove] objects.
 */
class WcaAlgorithm {
  /**
   * The moves in the algorithm.
   */
  final List<WcaMove> moves;
  
  /**
   * Create an algorithm from moves.
   */
  WcaAlgorithm.fromMoves(this.moves);
  
  /**
   * Parse a WCA algorithm.
   */
  WcaAlgorithm.fromString(String str) : moves = new List<WcaMove>() {
    List<String> comps = str.split(new RegExp(r'\s+'));
    for (String comp in comps) {
      moves.add(new WcaMove.fromString(comp));
    }
  }
  
  /**
   * Returns a WCA-standard algorithm.
   */
  String toString() => moves.join(' ');
}
