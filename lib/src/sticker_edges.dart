part of cube;

/**
 * Sticker edge orientations.
 */
class StickerEdges extends Edges {
  final StickerState state;
  
  int get size => state.size;
  
  /**
   * Wrap a [StickerState].
   */
  StickerEdges(this.state);
  
  bool isOriented(int dedgeSlot, int edgeSlot, int axis) {
    List<int> colors = edgeColors(dedgeSlot, edgeSlot);
    // TODO: here, hardcode the EO rules for every color scheme
  }
  
  int readEdge(int dedgeSlot, int edgeSlot) {
    List<int> colors = edgeColors(dedgeSlot, edgeSlot);
    List<List<int>> signatures = [[0, 2], [0, 4], [0, 3], [0, 5], [2, 5],
                                  [2, 4], [1, 2], [1, 4], [1, 3], [1, 5],
                                  [3, 5], [3, 4]];
    for (int i = 0; i < signatures.length; ++i) {
      List<int> sig = signatures[i];
      if (colors.contains(sig[0]) && colors.contains(sig[1])) {
        return i;
      }
    }
    throw new StateError('unable to identify edge: $colors');
  }
  
  /**
   * Returns a list containing three numbers. The first is the sticker color of
   * the edge on the x-axis; the next is the color on the y-axis; the third is
   * the color on the z-axis. Since one of these three colors does not exist
   * for a given edge, that element will be -1.
   */
  List<int> edgeColors(int dedgeSlot, int edgeSlot) {
    // I busted my ass writing this so *you* don't have to :)
    switch (dedgeSlot) {
      case 0: // FU
        return [-1, state.top.getSticker(edgeSlot + 1, size - 1),
                state.front.getSticker(edgeSlot + 1, 0)];
      case 1: // FR
        return [state.right.getSticker(0, size - edgeSlot - 1), -1,
                state.front.getSticker(size - 1, size - edgeSlot - 1)];
      case 2: // FD
        return [-1, state.bottom.getSticker(edgeSlot + 1, 0),
                state.front.getSticker(edgeSlot + 1, size - 1)];
      case 3: // FL
        return [state.left.getSticker(size - 1, size - edgeSlot - 1), -1,
                state.front.getSticker(0, size - edgeSlot - 1)];
      case 4: // UL
        return [state.left.getSticker(edgeSlot + 1, 0),
                state.top.getSticker(0, edgeSlot + 1), -1];
      case 5: // UR
        return [state.right.getSticker(size - edgeSlot - 1, 0),
                state.top.getSticker(size - 1, edgeSlot + 1), -1];
      case 6: // BU
        return [-1, state.top.getSticker(edgeSlot + 1, 0),
                state.back.getSticker(size - edgeSlot - 1, 0)];
      case 7: // BR
        return [state.right.getSticker(size - 1, size - edgeSlot - 1),
                -1, state.back.getSticker(0, size - edgeSlot - 1)];
      case 8: // BD
        return [-1, state.bottom.getSticker(edgeSlot + 1, size - 1),
                state.back.getSticker(size - edgeSlot - 1, size - 1)];
      case 9: // BL
        return [state.left.getSticker(0, size - edgeSlot - 1), -1,
                state.back.getSticker(size - 1, size - edgeSlot - 1)];
      case 10: // DL
        return [state.left.getSticker(edgeSlot + 1, size - 1),
                state.bottom.getSticker(0, size - edgeSlot - 1),
                -1];
      case 11: // DR
        return [state.right.getSticker(size - edgeSlot - 1, size - 1),
                state.bottom.getSticker(size - 1, size - edgeSlot - 1),
                -1];
    }
    throw new RangeError.range(dedgeSlot, 0, 11);
  }
}