part of cube;

abstract class Move<S extends CubeState> {
  int get size;
  Permutation<S> get permutation;
  String get name;
}