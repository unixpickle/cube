part of cube;

class StickerCorners extends Corners {
  final StickerState state;
  
  int get size => state.size;
  
  StickerCorners(this.state);
  
  int readCorner(int slot) {
    List<int> colors = cornerColors(slot);
    bool xValue = colors.contains(4);
    bool yValue = colors.contains(2);
    bool zValue = colors.contains(0);
    return (xValue ? 4 : 0) | (yValue ? 2 : 0) | (zValue ? 1 : 0);
  }
  
  int readOrientation(int slot, int origAxis) {
    List<List<int>> axisColors = [[4, 5], [2, 3], [0, 1]];
    List<int> colors = cornerColors(slot);
    int idx = colors.indexOf(axisColors[origAxis][0]);
    if (idx >= 0) return idx;
    return colors.indexOf(axisColors[origAxis][1]);
  }
  
  List<int> cornerColors(int slot) {
    switch (slot) {
      case 0: // 0, 0, 0
        return [state.left.getSticker(0, size - 1),
                state.bottom.getSticker(0, size - 1),
                state.back.getSticker(size - 1, size - 1)];
      case 1: // 0, 0, 1
        return [state.left.getSticker(size - 1, size - 1),
                state.bottom.getSticker(0, 0),
                state.front.getSticker(0, size - 1)];
      case 2: // 0, 1, 0
        return [state.left.getSticker(0, 0),
                state.top.getSticker(0, 0),
                state.back.getSticker(size - 1, 0)];
      case 3: // 0, 1, 1
        return [state.left.getSticker(size - 1, 0),
                state.top.getSticker(0, size - 1),
                state.front.getSticker(0, 0)];
      case 4: // 1, 0, 0
        return [state.right.getSticker(size - 1, size - 1),
                state.bottom.getSticker(size - 1, size - 1),
                state.back.getSticker(0, size - 1)];
      case 5: // 1, 0, 1
        return [state.right.getSticker(0, size - 1),
                state.bottom.getSticker(size - 1, 0),
                state.front.getSticker(size - 1,  size - 1)];
      case 6: // 1, 1, 0
        return [state.right.getSticker(size - 1, 0),
                state.top.getSticker(size - 1, 0),
                state.back.getSticker(0, 0)];
      case 7: // 1, 1, 1
        return [state.right.getSticker(0, 0),
                state.top.getSticker(size - 1, size - 1),
                state.front.getSticker(size - 1, 0)];
    }
    throw new RangeError('invalid corner slot: $slot');
  }
}