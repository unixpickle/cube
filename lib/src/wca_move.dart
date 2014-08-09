part of cube;

/**
 * An abstract "move" compliant to the WCA spec.
 */
abstract class WcaMove {
  /**
   * The axis perpendicular to which this move takes place.
   */
  int get axis;
  
  /**
   * The power that a standard basis move is raised to in order to get this
   * move.
   */
  int get power;
  
  /**
   * Create a [WcaMove] subclass that corresponds to the given move.
   * 
   * If the move cannot be parsed, a [NotationError] is thrown.
   */
  factory WcaMove.fromString(String s) {
    try {
      return new WcaTurn.fromString(s);
    } catch (e) {
    }
    try {
      return new WcaSlice.fromString(s);
    } catch (e) {
    }
    try {
      return new WcaRotation.fromString(s);
    } catch (e) {
    }
    throw new NotationError('no such WCA move: $s');
  }
}

/**
 * An official face-turn or wide-turn which complies to the WCA standard move
 * notation.
 */
class WcaTurn implements WcaMove {
  /**
   * The face index this move applies to. This is a number between 0 and 5
   * (inclusive) which is an index into F, B, U, D, R, L.
   */
  final int face;
  
  /**
   * The number of layers this move affects. Outer turns have a width of 1, wide
   * turns have a width of greater than 1.
   */
  final int width;
  
  /**
   * The number of times this move should be applied. This must range from 1 to
   * 3 (inclusive). A power of 3 represents an inverse turn; a power of 2
   * indicates a half-turn.
   */
  final int power;
  
  int get axis => 2 - (face ~/ 2);
  
  WcaTurn(this.face, this.width, this.power) {
    assert(face >= 0 && face < 6);
    assert(power > 0 && power < 4);
  }
  
  WcaTurn.fromString(String s) : face = _parseFace(s), width = _parseWidth(s),
      power = _parsePower(s);
  
  String toString() {
    String faceName = 'FBUDRL'[face];
    String powerName = ['', '', '2', "'"][power];
    if (width == 1) return faceName + powerName;
    else if (width == 2) return faceName + 'w' + powerName;
    return '$width${faceName}w$powerName';
  }
  
  static List<String> _parseMove(String s) {
    Match m = new RegExp('^([0-9]*)([FBUDRL])(w?)([12\']?)\$').matchAsPrefix(s);
    if (m == null) {
      throw new NotationError('invalid WCA move: $s');
    }
    return m.groups([1, 2, 3, 4]);
  }

  static int _parseFace(String s) {
    return 'FBUDRL'.indexOf(_parseMove(s)[1]);
  }

  static int _parseWidth(String s) {
    List<String> match = _parseMove(s);
    String countStr = match[0];
    if (countStr == '') {
      if (match[2] == 'w') {
        return 2;
      }
      return 1;
    }
    return int.parse(countStr);
  }

  static int _parsePower(String s) {
    String match = _parseMove(s)[3];
    if (match == "'") return 3;
    if (match == '') return 1;
    return int.parse(match);
  }
}

/**
 * A slice turn in WCA notation.
 */
class WcaSlice implements WcaMove {
  final int axis;
  final int power;
  
  WcaSlice(this.axis, this.power);
  
  WcaSlice.fromString(String s) : axis = _parseSliceAxis(s),
      power = _parseSlicePower(s);
  
  String toString() {
    String faceName = ['M', 'E', 'S'][axis];
    String suffixName = ['', '', '2', "'"][power];
    return faceName + suffixName;
  }
  
  static List<String> _parseSlice(String s) {
    Match m = new RegExp(r"^([ESM])([12']?)$").matchAsPrefix(s);
    if (m == null) {
      throw new NotationError('invalid WCA slice: $s');
    }
    return m.groups([1, 2]);
  }

  static int _parseSliceAxis(String s) {
    String name = _parseSlice(s)[0];
    return {'E': 1, 'S': 2, 'M': 0}[name];
  }

  static int _parseSlicePower(String s) {
    String str = _parseSlice(s)[1];
    return {"'": 3, '2': 2, '1': 1, '': 1}[str];
  }
}

/**
 * A cube rotation in WCA notation.
 */
class WcaRotation implements WcaMove {
  final int axis;
  final int power;
  
  WcaRotation(this.axis, this.power);
  
  WcaRotation.fromString(String s) : axis = _parseRotationAxis(s),
      power = _parseRotationPower(s);
  
  String toString() {
    String faceName = ['x', 'y', 'z'][axis];
    String suffixName = ['', '', '2', "'"][power];
    return faceName + suffixName;
  }
  
  static List<String> _parseRotation(String s) {
    Match m = new RegExp(r"^([xyz])(['12]?)$").matchAsPrefix(s);
    if (m == null) {
      throw new NotationError('invalid WCA rotation: $s');
    }
    return m.groups([1, 2]);
  }
  
  static int _parseRotationAxis(String s) {
    String axisStr = _parseRotation(s)[0];
    return {'x': 0, 'y': 1, 'z': 2}[axisStr];
  }
  
  static int _parseRotationPower(String s) {
    String powerStr = _parseRotation(s)[1];
    return {'1': 1, '': 1, '2': 2, "'": 3}[powerStr];
  }
}
