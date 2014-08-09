part of cube;

/**
 * A general cube state. In the future, this will include a field for accessing
 * corners.
 */
abstract class CubeState {
  /**
   * The side length of the cube.
   */
  int get size;
  
  /**
   * The edges of the cube.
   */
  Edges get edges;
}
