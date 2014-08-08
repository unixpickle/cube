part of cube;

/**
 * A list of [StickerMove] objects.
 */
class StickerAlgorithm extends Algorithm<StickerState> {
  StickerAlgorithm(int theSize) : super(theSize);
  
  StickerAlgorithm.fromList(int theSize, List<Move<StickerState>> theMoves) :
      super.fromList(theSize, theMoves);
  
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
