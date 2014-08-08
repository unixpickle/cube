part of cube;

/**
 * A list of [StickerMove] objects.
 */
class StickerAlgorithm {
  int size;
  final List<StickerMove> moves;
  
  StickerAlgorithm.fromWca(this.size, WcaAlgorithm algo) : moves = [] {
    for (WcaMove move in algo.moves) {
      moves.add(new StickerMove.fromWca(size, move));
    }
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
  
  String toString() => moves.join(' ');
}
