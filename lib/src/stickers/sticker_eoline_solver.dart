part of cube;

/**
 * Solve the EOLine on a sticker state.
 */
class StickerEOLineSolver extends EOLineSolver<StickerState> {
  /**
   * Create a new solver.
   */
  StickerEOLineSolver(StickerState state, EOLineHeuristics heuristics) :
      super(state, _generateStickerBasis(), new StickerAlgorithm(3),
            heuristics);
  
  static List<StickerMove> _generateStickerBasis() {
    String algoStr = "F B U D R L F' B' U' D' R' L' F2 B2 U2 D2 R2 L2";
    WcaAlgorithm wcaAlgo = new WcaAlgorithm.fromString(algoStr);
    StickerAlgorithm algo = new StickerAlgorithm.fromWca(3, wcaAlgo);
    return algo.moves;
  }
}
