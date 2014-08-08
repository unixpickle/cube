part of cube;

class StickerEOLineSolver extends EOLineSolver<StickerState> {
  StickerEOLineSolver(StickerState state) :
      super(state, new StickerAlgorithm(3), _generateStickerBasis());
  
  static List<StickerMove> _generateStickerBasis() {
    String algoStr = "F B U D R L F' B' U' D' R' L' F2 B2 U2 D2 R2 L2";
    WcaAlgorithm wcaAlgo = new WcaAlgorithm.fromString(algoStr);
    StickerAlgorithm algo = new StickerAlgorithm.fromWca(3, wcaAlgo);
    return algo.moves;
  }
}
