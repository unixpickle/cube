part of cube;

abstract class Algorithm<S extends CubeState> {
  final int size;
  final List<Move<S>> moves;
  
  Algorithm(this.size) : moves = [];
  
  Algorithm.fromList(this.size, this.moves);
  
  Algorithm<S> generate(List<Move<S>> moves);
  
  S toState();
  Permutation<S> toPermutation();
  
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
  
  String toString() => moves.join(' ');
}
