part of cube;

/**
 * An algorithm is simply an ordered list of moves. A [WcaAlgorithm] represents
 * a chain of [WcaMove] objects.
 */
class WcaAlgorithm {
  final List<WcaMove> moves;
  
  WcaAlgorithm.fromString(String str) : moves = new List<WcaMove>() {
    List<String> comps = str.split(new RegExp(r'\s+'));
    for (String comp in comps) {
      moves.add(new WcaMove.fromString(comp));
    }
  }
  
  String toString() => moves.join(' ');
}
