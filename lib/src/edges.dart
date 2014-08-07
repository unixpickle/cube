part of cube;

/**
 * Represents the edges of a cube.
 * 
 * Edges are individual two-sided pieces on a cube. Edges are grouped into 12
 * dedges. During a reduction solve on a big cube, the process of "edge pairing"
 * is when the solver groups edges of identical colors together into one dedge.
 * On a 3x3x3, there is a perfect 1-to-1 mapping between edges and dedges.
 * 
 * Dedges are addressed as indices from 0 to 11 inclusive. These refer to the
 * following slots respectively: FU, FR, FD, FL, UL, UR, BU, BR, BD, BL, DL, DR.
 * 
 * Inside each dedge, there are zero or more edges. On a 3x3x3, there is exactly
 * one edge per dedge. However, on a 5x5x5, there are 3 edges in each dedge.
 * Thus, it is clear that edges must be addressed not only by a dedge index, but
 * also by an index within a dedge.
 * 
 * For dedges that run along the x axis, edges are indexed from left to right;
 * for y axis dedges, edges are indexed from bottom to top; for z axis dedges,
 * edges are indexed from back to front.
 * 
 * As an example, the edges in the FU dedge are ordered from left to right, so
 * edge zero of dedge zero on a 5x5x5 is the leftmost edge in the top front
 * dedge's position.
 */
abstract class Edges {
  /**
   * The side length of the cube.
   */
  int get size;
  
  /**
   * Returns `true` if the specified edge is oriented with respect to the faces
   * perpendicular to a particular [axis].
   * 
   * The [axis] is 0 for x, 1 for y, or 2 for z. For example, the ZZ method uses
   * EO on the z axis, so this would be axis 2.
   */
  bool isOriented(int dedgeSlot, int edgeSlot, int axis);
  
  /**
   * Looks up the edge at a specified [edgeSlot] within the specified
   * [dedgeSlot] and returns the dedge index where it belongs in a solved cube.
   * 
   * For example, if you apply an R move to a cube, calling `readEdge(5, 0)`
   * will return 1 because the edge located in the UR position originated from
   * the FR position.
   */
  int readEdge(int dedgeSlot, int edgeSlot);
  
  /**
   * Returns a list of results from [isOriented]. The results are ordered first
   * by dedge and then by edge.
   */
  List<bool> orientationsForAxis(int axis) {
    if (size <= 2) return [];
    
    List<bool> res = new List<bool>();
    for (int i = 0; i < 12; ++i) {
      for (int j = 0; j < size - 2; ++j) {
        res.add(isOriented(i, j, axis));
      }
    }
    return res;
  }
}
