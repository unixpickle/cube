part of cube;

/**
 * A named permutation on a [CubeState].
 */
abstract class Move<S extends CubeState> {
  /**
   * The size of the cube this move applies to.
   */
  int get size;
  
  /**
   * The permutation that this move applies.
   */
  Permutation<S> get permutation;
  
  /**
   * The name of this move.
   */
  String get name;
}