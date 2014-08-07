part of cube;

int _countTrues(int countInfo, List<bool> list) {
  if (countInfo >= 0) return countInfo;
  int count = 0;
  for (bool b in list) {
    if (b) ++count;
  }
  return count;
}

/**
 * Generate [a] unordered-choose [b].
 */
int _choose(int a, int b) {
  // a!/(b!)(a - b)!
  int endFac = 1;
  for (int i = a; i > a - b; --i) {
   endFac *= i;
  }
  int bFac = 1;
  for (int i = 2; i <= b; i++) {
   bFac *= i;
  }
  return endFac ~/ bFac;
}

/**
 * A representation of an unordered subset of a larger set.
 * 
 * Combinatorics defines the choose operator as follows: if you have a set S of
 * N elements, N choose M is the number of subsets of S that contain M elements.
 * 
 * The choose operator is very useful for cube theory. For instance, take the
 * 3x3x3 with 12 edges. The number of EO cases with four disoriented edges can
 * be computed as 12 choose 4.
 * 
 * When encoding certain heuristics, it can be beneficial to perfectly hash a
 * subset of a larger set. For example, an edge orientation case could be
 * encoded as a subset selected from a set of 11 elements (11, not 12, because
 * there must be an even number of oriented edges).
 */
class ChooseMap {
  /**
   * A list of N booleans. If a boolean is `true`, it indicates that the
   * corresponding element has been selected for the subset. For instance, a
   * subset `{1, 3, 6}` could be represented as a subset of `{1, 2, 3, 4, 5, 6}`
   * as `[true, false, true, false, false, true]`
   */
  final List<bool> choices;
  
  /**
   * The size of the selected subset.
   */
  final int choiceCount;
  
  int _hashCode;
  
  /**
   * A [ChooseMap] corresponding to all but the first element of this map.
   */
  ChooseMap get tail {
    if (choices.length == 0) {
      return new ChooseMap.fromChoices([]);
    }
    if (choices[0]) {
      return new ChooseMap.fromChoices(choices.sublist(1),
          count: choiceCount - 1);
    } else {
      return new ChooseMap.fromChoices(choices.sublist(1), count: choiceCount);
    }
  }
  
  /**
   * Create a [ChooseMap] from a list of choices. If you do not provied a choice
   * [count], it will automatically be computed.
   */
  ChooseMap.fromChoices(List<bool> theChoices, {int count: -1}) :
      choices = theChoices, choiceCount = _countTrues(count, theChoices) {
    _hashCode = -1;
  }
  
  /**
   * Returns [choices].length choose [choiceCount]. This represents the number
   * of unique subsets of length [choiceCount] that could be chosen from the
   * set represented by [choices].
   */
  int get hashCount => _choose(choices.length, choiceCount);
  
  /**
   * Generates a unique hash for this particular subset of the larger set. This
   * hash is between 0 (inclusive) and [hashCount] (exclusive).
   */
  int get hashCode {
    if (choices.length == 0) return 0;
    else if (choiceCount == 0) return 0;
    else if (_hashCode >= 0) return _hashCode;
    else if (choices[0]) {
      return _hashCode = tail.hashCode;
    } else {
      int passed = _choose(choices.length - 1, choiceCount - 1);
      return _hashCode = tail.hashCode + passed;
    }
  }
}
