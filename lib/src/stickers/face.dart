part of cube;

/**
 * A two-dimensional face of a [StickerState].
 */ 
class Face {
  /**
   * A map from numeric sticker colors to color characters. The default map is
   * as follows: `['G', 'B', 'W', 'Y', 'R', 'O']`. This is the standard WCA
   * color scheme.
   */
  static final List<String> COLORS = ['G', 'B', 'W', 'Y', 'R', 'O'];
  
  /**
   * The side-length of the face. For example, a Rubik's cube's faces would have
   * a [size] of 3.
   */
  final int size;
  
  final List<int> _stickers;
  final int _offset;
  
  Face._(this.size, this._stickers, this._offset);
  
  /**
   * Return the stickers on this face, ordered from left to right, top to
   * bottom. For example, the second sticker corresponds to the coordinate
   * (1,0).
   */
  Iterable<int> get stickers => _stickers.getRange(_offset, size * size);
  
  /**
   * Return the sticker at a given index. The indices go from left to right, top
   * to bottom. For example, the second sticker corresponds to the coordinate
   * (1,0).
   */
  int operator [](int idx) => _stickers[_offset + idx];
  
  /**
   * Set the sticker at a given index. The indices go from left to right, top to
   * bottom. For example, the second sticker corresponds to the coordinate
   * (1,0).
   */
  void operator []=(int idx, int value) {
    _stickers[_offset + idx] = value;
  }
  
  /**
   * Return the sticker at a given coordinate on this face. Both [x] and [y]
   * must be in the range from 0 to `size - 1` inclusive.
   */
  int getSticker(int x, int y) {
    assert(x < size && x >= 0);
    assert(y < size && y >= 0);
    return _stickers[_offset + x + (size * y)];
  }
  
  /**
   * Convert this face to a compact list of colors. By default, this uses the
   * color map stored in [COLORS].
   */
  String toString({List<String> stickerNames: null}) {
    if (stickerNames == null) {
      stickerNames = COLORS;
    }
    StringBuffer buf = new StringBuffer();
    for (int i = 0; i < size * size; ++i) {
      buf.write(stickerNames[_stickers[_offset + i]]);
    }
    return buf.toString();
  }
}
