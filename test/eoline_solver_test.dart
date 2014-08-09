import 'package:cube/cube.dart';
import 'dart:async';
import 'dart:io';

void main() {
  String fourFlip = "M' U' M' U' M' U' M' U'";
  //String algoStr = "$fourFlip x' z' $fourFlip x' z' $fourFlip x' z'";
  //String algoStr = "F B' D2 L2 R B F L' R2 B2 D'";
  String algoStr = 'F';
  WcaAlgorithm wcaAlgo = new WcaAlgorithm.fromString(algoStr);
  StickerAlgorithm a = new StickerAlgorithm.fromWca(3, wcaAlgo);
  solveEOLine(a.toState()).listen((algo) {
    print('algo $algo');
  });
}

Stream<StickerAlgorithm> solveEOLine(StickerState state) {
  List<int> fullHeuristic = new File('packages/cube/heuristics/eoline.bin')
      .readAsBytesSync();
  EOLineHeuristics heuristics = new EOLineHeuristics.full(fullHeuristic);
  return new StickerEOLineSolver(state, heuristics).stream;
}
