part of cube;

List<WcaMove> generateWCABasis(int size) {
  List<WcaMove> result = [];
  for (int face = 0; face < 6; ++face) {
    for (int width = 1; width <= size ~/ 2; ++width) {
      for (int power = 1; power <= 3; ++power) {
        result.add(new WcaTurn(face, width, power));
      }
    }
  }
  return result;
}

WcaAlgorithm generateWCAScramble(int size, int length, {Random rand: null}) {
  if (rand == null) {
    rand = new Random();
  }
  
  List<WcaMove> moves = [];
  List<WcaMove> basis = generateWCABasis(size);
  List<WcaMove> remaining = new List<WcaMove>.from(basis);
  int lastAxis = -1;
  for (int i = 0; i < length; ++i) {
    assert(remaining.length != 0);
    int idx = rand.nextInt(remaining.length);
    WcaMove move = remaining[idx];
    
    // refill the list before removing this move
    if (move.axis != lastAxis) {
      remaining = new List<WcaMove>.from(basis);
      lastAxis = move.axis;
      idx = remaining.indexOf(move);
    }
    
    int start;
    if (idx % 3 == 0) {
      start = idx;
    } else {
      start = idx - (idx % 3);
    }
    remaining.removeRange(start, start + 3);
    moves.add(move);
  }
  return new WcaAlgorithm.fromMoves(moves);
}
