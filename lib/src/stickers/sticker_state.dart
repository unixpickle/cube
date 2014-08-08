part of cube;

List<int> _stickerIdentity(int size) {
  return new List<int>.generate(size * size * 6, (int i) => i ~/ (size * size),
      growable: false);
}

/**
 * Represents the visual state of a cube. This is a raw map of stickers rather
 * than a permutation.
 */
class StickerState extends CubeState {
  /**
   * The side length of this cube. For example, a 4x4x4 would have a [size] of
   * 4.
   */
  final int size;
  
  /**
   * The square of [size]. For example, a 4x4x4 would have a [faceCount] of 16.
   */
  final int faceCount;
  
  /**
   * The list of stickers which backs this state. The first [faceCount] values
   * correspond to the front face, the next [faceCount] to the back face, etc.
   * in the following order: front, back, top, bottom, right, left.
   */
  final List<int> stickers;
  
  /**
   * This state's front face.
   */
  Face get front => new Face._(size, stickers, 0);
  
  /**
   * This state's back face.
   */
  Face get back => new Face._(size, stickers, faceCount);
  
  /**
   * This state's top face.
   */
  Face get top => new Face._(size, stickers, faceCount * 2);
  
  /**
   * This state's bottom face.
   */
  Face get bottom => new Face._(size, stickers, faceCount * 3);
  
  /**
   * This state's right face.
   */
  Face get right => new Face._(size, stickers, faceCount * 4);
  
  /**
   * This state's left face.
   */
  Face get left => new Face._(size, stickers, faceCount * 5);
  
  /**
   * This state's edges.
   */
  Edges get edges => new StickerEdges(this);
  
  /**
   * Create a new solved cube of side length [s].
   */
  StickerState.identity(int s) : size = s, faceCount = s * s,
      stickers = _stickerIdentity(s);
  
  /**
   * Duplicate a [state].
   */
  StickerState.copy(StickerState state) : faceCount = state.faceCount,
      size = state.size, stickers = new List.from(state.stickers,
          growable: false);
  
  /**
   * Create a [StickerState] from a raw list of stickers.
   */
  StickerState.raw(int s, this.stickers) : size = s, faceCount = s * s {
    assert(faceCount * 6 == stickers.length);
  }
  
  /**
   * Convert this [StickerState] to a human-readable string. The string includes
   * the cube's [size], as well as each of its faces.
   * 
   * You may optionally provide a [stickerNames] map used to convert each face
   * to a string.
   */
  String toString({List<String> stickerNames: null}) {
    if (stickerNames == null) {
      return '<CubeState size=$size front=$front back=$back top=$top ' +
          'bottom=$bottom right=$right left=$left>';
    } else {
      StringBuffer buf = new StringBuffer('<CubeState size=$size');
      List<String> names = ['front', 'back', 'top', 'bottom', 'right', 'left'];
      List<Face> faces = [front, back, top, bottom, right, left];
      for (int i = 0; i < 6; i++) {
        String faceStr = faces[i].toString(stickerNames: stickerNames);
        buf.write(' ${names[i]}=${faceStr}');
      }
      buf.write('>');
      return buf.toString();
    }
  }
}
