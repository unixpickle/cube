part of cube;

/**
 * A set of [Move]s.
 */
abstract class Algorithm<S extends CubeState> {
  /**
   * The size of the cubes that this algorithm may apply to.
   */
  final int size;
  
  /**
   * The moves of this algorithm.
   */
  final List<Move<S>> moves;
  
  /**
   * Create an empty algorithm.
   */
  Algorithm(this.size) : moves = [];
  
  /**
   * Create an algorithm from a list.
   */
  Algorithm.fromList(this.size, this.moves);
  
  /**
   * Generate another algorithm of this instance using a list of moves.
   */
  Algorithm<S> generate(List<Move<S>> moves);
  
  /**
   * Apply this algorithm to an identity state and return the result.
   */
  S toState();
  
  /**
   * Return the effective permutation of this entire algorithm.
   */
  Permutation<S> toPermutation();
  
  /**
   * Concatenate this algorithm on the left of another one and return the
   * result. You may also do `algorithm + move`. 
   */
  Algorithm<S> operator +(dynamic arg) {
    List<Move<S>> newMoves = new List<Move<S>>.from(moves);
    if (arg is Algorithm<S>) {
      Algorithm<S> algo = arg;
      assert(size == algo.size);
      newMoves.addAll(algo.moves);
    } else if (arg is Move<S>) {
      newMoves.add(arg);
    } else {
      throw new ArgumentError('invalid object passed to +: $arg');
    }
    return generate(newMoves);
  }
  
  /**
   * Convert this algorithm to a human-readable string.
   */
  String toString() => moves.join(' ');
}
