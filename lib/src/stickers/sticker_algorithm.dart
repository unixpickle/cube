part of cube;

/**
 * A list of [StickerMove] objects.
 */
class StickerAlgorithm extends Algorithm<StickerState> {
  /**
   * Create an empty algorithm.
   */
  StickerAlgorithm(int theSize) : super(theSize);
  
  /**
   * Create an algorithm from a list of moves.
   */
  StickerAlgorithm.fromList(int theSize, List<Move<StickerState>> theMoves) :
      super.fromList(theSize, theMoves);
  
  /**
   * Create an algorithm from a WCA algorithm.
   */
  StickerAlgorithm.fromWca(int theSize, WcaAlgorithm algo) : super(theSize) {
    for (WcaMove move in algo.moves) {
      moves.add(new StickerMove.fromWca(size, move));
    }
  }
  
  StickerAlgorithm generate(List<Move<StickerState>> moves) {
    return new StickerAlgorithm.fromList(size, moves);
  }
  
  StickerPerm toPermutation() {
    StickerPerm res = new StickerPerm.identity(size);
    for (StickerMove move in moves) {
      res = move.permutation.applyToPermutation(res);
    }
    return res;
  }
  
  StickerState toState() {
    return toPermutation().toState();
  }
}
