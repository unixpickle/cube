part of cube;

List<int> _identityList(int size) {
  return new List<int>.generate(size * size * 6, (int i) => i,
      growable: false);
}

/**
 * Represents a cube permutation. This could be a face turn, an algorithm, or
 * the effect of any cube application.
 */
class StickerPermutation {
  /**
   * The side length that a [StickerState] must have in order to perform this
   * [StickerPermutation].
   */
  final int size;
  
  /**
   * The permutation map. If a permutation on X elements is applied to the list
   * `[0, ..., X - 1]`, its [map] is the resulting list.
   */
  final List<int> map;
  
  /**
   * Create a new [StickerPermutation] given a side length [size] and a
   * permutation [map]. The length of [map] must be 6 * [size] ^ 2.
   */
  StickerPermutation(this.size, this.map) {
    assert(map.length == size * size * 6);
  }
  
  /**
   * Create an identity [StickerPermutation] of size [s].
   */
  StickerPermutation.identity(int s) : size = s, map = _identityList(s);
  
  /**
   * Create a [StickerPermutation] that acts as a clockwise quarter turn on a
   * [face] of a cube of size [s]. The [face] index starts at 0 and is ordered
   * as follows: F, B, U, D, R, L.
   */
  StickerPermutation.faceTurn(int s, int face) : size = s,
      map = _identityList(s) {
    assert(face >= 0 && face < 6);
    int faceSize = size * size;
    
    // permute the surface of the face
    int start = faceSize * face;
    for (int x = 0; x < size; ++x) {
      for (int y = 0; y < size; ++y) {
        int destY = x;
        int destX = size - y - 1;
        int dest = start + destX + destY * size;
        int source = start + x + size * y;
        map[dest] = source;
      }
    }
    
    // permute the "slice" around the face
    switch (face) {
      case 0:
        _permuteSlice(2, size - 1, 1);
        break;
      case 1:
        _permuteSlice(2, 0, 3);
        break;
      case 2:
        _permuteSlice(1, size - 1, 3);
        break;
      case 3:
        _permuteSlice(1, 0, 1);
        break;
      case 4:
        _permuteSlice(0, size - 1, 3);
        break;
      case 5:
        _permuteSlice(0, 0, 1);
        break;
    }
  }
  
  /**
   * Create a [StickerPermutation] that acts as a slice on a cube of a given
   * [size].
   * 
   * The [axis] argument specifies which slice to perform. The axes are ordered
   * x, y, z starting at 0: axis 0 is an M slice; axis 1 is an E slice; and axis
   * 2 is an S slice. Slices on axis 0 go the same way as an `L` move; slices on
   * axis 1 go the same way as a `D` move; slices on axis 2 go the same way as
   * an `F` move.
   * 
   * The [offset] argument specifies which layer to slice. The [offset] must
   * range from 1 to [size] - 2. On [axis] 0, the [offset] goes from left to
   * right; on [axis] 1, it goes from bottom to top; on [axis] 2, it goes from
   * back to front.
   * 
   * As an example, an `r'` turn on a 4x4x4 would have an [axis] of 0 and an
   * [offset] of 2, while an `l` turn would have an [axis] of 0 and an [offset]
   * of 1.
   */
  StickerPermutation.slice(int s, int axis, int offset) : size = s,
      map = _identityList(s) {
    assert(offset > 0 && offset < size - 1);
    assert(axis >= 0 && axis < 3);
    
    // permute the slice
    _permuteSlice(axis, offset, 1);
  }
  
  StickerPermutation applyToPermutation(StickerPermutation perm) {
    assert(perm.size == size);
    List<int> resMap = new List<int>.filled(map.length, 0);
    for (int i = 0; i < map.length; ++i) {
      resMap[i] = perm.map[map[i]];
    }
    return new StickerPermutation(size, resMap);
  }
  
  StickerState applyToState(StickerState state) {
    assert(size == state.size);
    List<int> resStickers = new List<int>(map.length);
    for (int i = 0; i < map.length; ++i) {
      resStickers[i] = state.stickers[map[i]];
    }
    return new StickerState.raw(size, resStickers);
  }
  
  StickerState toState() {
    List<int> resStickers = new List<int>(map.length);
    for (int i = 0; i < map.length; ++i) {
      resStickers[i] = map[i] ~/ (size * size);
    }
    return new StickerState.raw(size, resStickers);
  }
  
  void _permuteSlice(int axis, int offset, int count) {
    // read the slice, permute it, and write it back
    List<int> slice = _readSlice(axis, offset);
    List<int> end = slice.sublist(size * 3);
    slice.removeRange(size * 3, size * 4);
    slice.insertAll(0, end);
    _writeSlice(axis, offset, slice);
    
    if (count > 1) {
      _permuteSlice(axis, offset, count - 1);
    }
  }
  
  List<int> _sliceIndices(int axis, int offset) {
    assert(offset >= 0 && offset < size);
    assert(axis >= 0 && axis < 3);
    List<int> result = new List<int>();
    int faceCount = size * size;
    
    // This is a rather verbose way of doing this, but it actually works quite
    // well; I feel that this is more clear than having a large array of info
    // sitting around.
    
    if (axis == 0) {
      // front face
      for (int i = 0; i < size; ++i) {
        result.add(i * size + offset);
      }
      // down face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 3 + i * size + offset);
      }
      // back face
      for (int i = size - 1; i >= 0; --i) {
        result.add(faceCount + i * size + (size - offset - 1));
      }
      // top face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 2 + i * size + offset);
      }
    } else if (axis == 1) {
      int yOffset = size * (size - offset - 1);
      
      // front face
      for (int i = 0; i < size; ++i) {
        result.add(yOffset + i);
      }
      // right face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 4 + yOffset + i);
      }
      // back face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount + yOffset + i);
      }
      // left face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 5 + yOffset + i);
      }
    } else if (axis == 2) {
      // this one was by FAR the hardest!
      
      // top face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 2 + offset * size + i);
      }
      // right face
      for (int i = 0; i < size; ++i) {
        result.add(faceCount * 4 + i * size + (size - offset - 1));
      }
      // down face
      for (int i = size - 1; i >= 0; --i) {
        result.add(faceCount * 3 + i + (size - offset - 1) * size);
      }
      // left face
      for (int i = size - 1; i >= 0; --i) {
        result.add(faceCount * 5 + i * size + offset);
      }
    }
    
    assert(result.length == size * 4);
    return result;
  }
  
  List<int> _readSlice(int axis, int offset) {
    List<int> indices = _sliceIndices(axis, offset);
    return new List.from(indices.map((int x) => map[x]));
  }
  
  void _writeSlice(int axis, int offset, List<int> values) {
    List<int> indices = _sliceIndices(axis, offset);
    for (int i = 0; i < indices.length; i++) {
      map[indices[i]] = values[i];
    }
  }
}
