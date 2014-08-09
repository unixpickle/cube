part of cube;

/**
 * A set of heuristics used for solving the EO Line efficiently.
 */
class EOLineHeuristics {
  /**
   * The index data for solving the front line edge and orienting every edge.
   */
  final List<int> frontIndex;
  
  /**
   * The index data for solving the back line edge and orienting every edge.
   */
  final List<int> backIndex;
  
  /**
   * Create a new EOLine heuristic using heuristic data. Ideally, you would
   * load [frontIndex] from `heuristics/zzfront.bin` and [backIndex] from
   * `heuristics/zzback.bin`.
   */
  EOLineHeuristics(this.frontIndex, this.backIndex);
  
  /**
   * A lower-bound heuristic for solving the EOLine.
   */
  int moveCount(Edges edges) {
    return max(frontIndex[hashEOAndEdge(edges, 2, 2)],
        backIndex[hashEOAndEdge(edges, 2, 8)]);
  }
  
  /**
   * Generates a unique hash from 0 to 2047 (inclusive) which represents the
   * edge orientation case on the cube.
   * 
   * The [axis] argument specifiecs the edge orientation scheme. In the desired
   * scheme, an edge is good if it can be solved without turning the two faces
   * perpendicular to [axis]. The axis is identified by a number 0 through 2 for
   * the axis x, y, and z respectively. The ZZ method uses an [axis] of 2.
   */
  static int hashEO(Edges edges, int axis) {
    int res = 0;
    for (int i = 0; i < 11; ++i) {
      bool oriented = edges.isOriented(i, 0, axis);
      if (oriented) {
        res |= 1 << i;
      }
    }
    return res;
  }
  
  /**
   * Generate a unique hash of the state of the FD and BD edges. This ranges
   * between 0 and 527 inclusive.
   */
  static int hashEOLineEdges(Edges edges) {
    int frontPos = -1;
    int backPos = -1;
    for (int i = 0; i < 12; ++i) {
      int edge = edges.readEdge(i, 0);
      if (edge == 2) frontPos = i;
      else if (edge == 8) backPos = i;
    }
    assert(frontPos >= 0 && backPos >= 0);
    int orientations = 0;
    if (edges.isOriented(frontPos, 0, 2)) {
      orientations |= 1;
    }
    if (edges.isOriented(backPos, 0, 2)) {
      orientations |= 2;
    }
    if (backPos > frontPos) --backPos;
    return backPos + frontPos * 11 + 132 * orientations;
  }
  
  /**
   * Hash the edge orientations and the position of an edge.
   */
  static int hashEOAndEdge(Edges edges, int axis, int edge) {
    int result = hashEO(edges, axis);
    for (int i = 0; i < 12; ++i) {
      if (edges.readEdge(i, 0) == edge) {
        return result + i * 2048;
      }
    }
    throw new StateError('missing edge: $edge');
  }
}
