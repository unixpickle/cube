part of cube;

/**
 * A permutation that may act on a [CubeState].
 */
abstract class Permutation<S extends CubeState> {
  /**
   * The side length of cubes that this permutation may apply to.
   */
  int get size;
  
  /**
   * Apply this permutation to another permutation of the same class and return
   * a third permutation of the same class.
   */
  Permutation<S> applyToPermutation(dynamic perm);
  
  /**
   * Apply this permutation to a state and return a new state.
   */
  S applyToState(S state);
  
  /**
   * Apply this permutation to the identity state and return the result.
   */
  S toState();
}
