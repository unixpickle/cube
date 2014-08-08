part of cube;

StickerPerm _wideTurnStickerPerm(int size, int face, int width, int power) {
  assert(width <= size);
  
  // start off with a single face turn on the specified side
  StickerPerm single = new StickerPerm.faceTurn(size, face);
  
  // apply inner slices that correspond with each move; some trickery needs to
  // be done here to translate WCA notation to our internal move representation.
  int slicePower = [0, 3, 5].contains(face) ? 1 : 3;
  bool flipOrder = [0, 2, 4].contains(face);
  int axis = 2 - (face ~/ 2);
  for (int i = 1; i < width && i < size - 1; ++i) {
    int offset = flipOrder ? size - i - 1 : i;
    StickerPerm slice = new StickerPerm.slice(size, axis, offset)
        .repeated(slicePower);
    single = slice.applyToPermutation(single);
  }
  
  // if this is a full cube rotation, we need to do another face turn
  if (width == size) {
    int opFace = [1, 0, 3, 2, 5, 4][face];
    StickerPerm turn = new StickerPerm.faceTurn(size, opFace).repeated(3);
    single = turn.applyToPermutation(single);
  }
  
  return single.repeated(power);
}

StickerPerm _sliceStickerPerm(int size, int axis, int power) {
  StickerPerm single = new StickerPerm.identity(size);
  for (int i = 1; i < size - 1; ++i) {
    single = new StickerPerm.slice(size, axis, i).applyToPermutation(single);
  }
  return single.repeated(power);
}

StickerPerm _wcaMoveStickerPerm(int size, WcaMove move) {
  if (move is WcaTurn) {
    WcaTurn turn = move;
    return _wideTurnStickerPerm(size, turn.face, turn.width, turn.power);
  } else if (move is WcaRotation) {
    if (move.axis == 0) {
      return _wideTurnStickerPerm(size, 4, size, move.power);
    } else if (move.axis == 1) {
      return _wideTurnStickerPerm(size, 2, size, move.power);
    } else {
      return _wideTurnStickerPerm(size, 0, size, move.power);
    }
  } else {
    return _sliceStickerPerm(size, move.axis, move.power);
  }
}

/**
 * Represents a named move on a [StickerState].
 * 
 * Generating a [StickerMove] from a move from another notation may be rather
 * inefficient. It is recommended that you translate a standard basis to a list
 * of [StickerMove]s early on in your program and reuse it.
 */
class StickerMove extends Move<StickerState> {
  final int size;
  final String name;
  final StickerPerm permutation;
  
  StickerMove.fromWca(int theSize, WcaMove move) : size = theSize,
      name = move.toString(),
      permutation = _wcaMoveStickerPerm(theSize, move);
  
  String toString() => name;
}
