part of cube;

abstract class Permutation<S extends CubeState> {
  int get size;
  
  Permutation<S> applyToPermutation(dynamic perm);
  S applyToState(S state);
  S toState();
}
