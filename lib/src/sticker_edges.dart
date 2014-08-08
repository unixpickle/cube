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
    assert(axis >= 0 && axis < 3);
    List<int> colors = edgeColors(dedgeSlot, edgeSlot);
        
    // use the ZZ edge orientation rules to determine if it's good or bad
    if (axis == 0) {
      // look at the E slice and use the right or top color to determine if it's
      // good or bad
      bool isSliceEdge = (colors.contains(0) || colors.contains(1)) &&
          (colors.contains(4) || colors.contains(5));
      bool isSliceSlot = [1, 3, 7, 9].contains(dedgeSlot);
      if (isSliceEdge) {
        if (isSliceSlot) {
          return [4, 5].contains(colors[0]);
        } else {
          return [4, 5].contains(colors[1]);
        }
      } else {
        if (isSliceSlot) {
          return [2, 3].contains(colors[0]);
        } else {
          return [2, 3].contains(colors[1]);
        }
      }
    } else if (axis == 1) {
      // look at the S slice and use the front or top color to determine if it's
      // good or bad
      bool isSliceEdge = (colors.contains(2) || colors.contains(3)) &&
          (colors.contains(4) || colors.contains(5));
      bool isSliceSlot = [4, 5, 10, 11].contains(dedgeSlot);
      if (isSliceEdge) {
        if (isSliceSlot) {
          return [2, 3].contains(colors[1]);
        } else {
          return [2, 3].contains(colors[2]);
        }
      } else {
        if (isSliceSlot) {
          return [0, 1].contains(colors[1]);
        } else {
          return [0, 1].contains(colors[2]);
        }
      }
    } else {
      // standard ZZ rules; using E slice with front or top color
      bool isSliceEdge = (colors.contains(0) || colors.contains(1)) &&
          (colors.contains(4) || colors.contains(5));
      bool isSliceSlot = [1, 3, 7, 9].contains(dedgeSlot);
      if (isSliceEdge) {
        if (isSliceSlot) {
          return [0, 1].contains(colors[2]);
        } else {
          return [0, 1].contains(colors[1]);
        }
      } else {
        if (isSliceSlot) {
          return [2, 3].contains(colors[2]);
        } else {
          return [2, 3].contains(colors[1]);
        }
      }
    }
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
        return [state.right.getSticker(0, size - edgeSlot - 2), -1,
                state.front.getSticker(size - 1, size - edgeSlot - 2)];
      case 2: // FD
        return [-1, state.bottom.getSticker(edgeSlot + 1, 0),
                state.front.getSticker(edgeSlot + 1, size - 1)];
      case 3: // FL
        return [state.left.getSticker(size - 1, size - edgeSlot - 2), -1,
                state.front.getSticker(0, size - edgeSlot - 2)];
      case 4: // UL
        return [state.left.getSticker(edgeSlot + 1, 0),
                state.top.getSticker(0, edgeSlot + 1), -1];
      case 5: // UR
        return [state.right.getSticker(size - edgeSlot - 2, 0),
                state.top.getSticker(size - 1, edgeSlot + 1), -1];
      case 6: // BU
        return [-1, state.top.getSticker(edgeSlot + 1, 0),
                state.back.getSticker(size - edgeSlot - 2, 0)];
      case 7: // BR
        return [state.right.getSticker(size - 1, size - edgeSlot - 2),
                -1, state.back.getSticker(0, size - edgeSlot - 2)];
      case 8: // BD
        return [-1, state.bottom.getSticker(edgeSlot + 1, size - 1),
                state.back.getSticker(size - edgeSlot - 2, size - 1)];
      case 9: // BL
        return [state.left.getSticker(0, size - edgeSlot - 2), -1,
                state.back.getSticker(size - 1, size - edgeSlot - 2)];
      case 10: // DL
        return [state.left.getSticker(edgeSlot + 1, size - 1),
                state.bottom.getSticker(0, size - edgeSlot - 2),
                -1];
      case 11: // DR
        return [state.right.getSticker(size - edgeSlot - 2, size - 1),
                state.bottom.getSticker(size - 1, size - edgeSlot - 2),
                -1];
    }
    throw new RangeError.range(dedgeSlot, 0, 11);
  }
}
