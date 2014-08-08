import 'package:cube/cube.dart';
import 'dart:io';

void main() {
  testRandom3x3x3();
  testRandom4x4x4();
}

void testRandom3x3x3() {
  print('testing with random 3x3x3...');
  var fMove = new StickerPerm.faceTurn(3, 0);
  var bMove = new StickerPerm.faceTurn(3, 1);
  var uMove = new StickerPerm.faceTurn(3, 2);
  var dMove = new StickerPerm.faceTurn(3, 3);
  var rMove = new StickerPerm.faceTurn(3, 4);
  var lMove = new StickerPerm.faceTurn(3, 5);
  
  // algorithm: F D B R F R U D R F B L F R L2
  
  List<StickerPerm> algorithm = [fMove, dMove, bMove, rMove, fMove, rMove,
                                 uMove, dMove, rMove, fMove, bMove, lMove,
                                 fMove, rMove, lMove, lMove];
  StickerPerm algoPerm = new StickerPerm.identity(3);
  for (StickerPerm move in algorithm) {
    algoPerm = move.applyToPermutation(algoPerm);
  }
  StickerState result = algoPerm.toState();
  
  // I did this algorithm to an actual cube so that I could test it out
  List<bool> zOrientations = <bool>[false, false, true, false, false, false,
                                    true, false, true, true, false, false];
  List<bool> xOrientations = <bool>[false, true, false, false, false, false,
                                    false, true, true, true, false, false];
  List<bool> yOrientations = <bool>[false, true, false, false, true, false,
                                    false, false, true, true, false, false];
  List<List<bool>> axesInfo = [xOrientations, yOrientations, zOrientations];
  List<List<int>> stickers = [[-1, 0, 3], [2, -1, 0], [-1, 0, 5], [1, -1, 5],
                              [3, 1, -1], [3, 5, -1], [-1, 1, 4], [3, -1, 4],
                              [-1, 2, 1], [4, -1, 0], [2, 5, -1], [2, 4, -1]];
  StickerEdges edges = new StickerEdges(result);
  for (int i = 0; i < 12; ++i) {
    List<int> testStickers = edges.edgeColors(i, 0);
    List<int> right = stickers[i];
    for (int j = 0; j < 3; ++j) {
      if (testStickers[j] != right[j]) {
        print('mismatching sticker values at dedge $i axis $j');
        exit(1);
      }
    }
  }
  
  for (int i = 0; i < 3; ++i) {
    List<bool> right = axesInfo[i];
    List<bool> tested = edges.orientationsForAxis(i);
    for (int j = 0; j < 12; ++j) {
      if (right[j] != tested[j]) {
        print('mismatching orientation for axis $i dedge $j');
        exit(1);
      }
    }
  }
  
  print('passed!');
}

void testRandom4x4x4() {
  print('testing with random 4x4x4...');
  var fMove = new StickerPerm.faceTurn(4, 0);
  var bMove = new StickerPerm.faceTurn(4, 1);
  var uMove = new StickerPerm.faceTurn(4, 2);
  var dMove = new StickerPerm.faceTurn(4, 3);
  var rMove = new StickerPerm.faceTurn(4, 4);
  var lMove = new StickerPerm.faceTurn(4, 5);
  var fSliceMove = new StickerPerm.slice(4, 2, 2);
  var bPrimeSliceMove = new StickerPerm.slice(4, 2, 1);
  var uPrimeSliceMove = new StickerPerm.slice(4, 1, 2);
  var dSliceMove = new StickerPerm.slice(4, 1, 1);
  var rPrimeSliceMove = new StickerPerm.slice(4, 0, 2);
  var lSliceMove = new StickerPerm.slice(4, 0, 1);
  
  // algorithm: F U d r' R l B u' b' L D f
  
  List<StickerPerm> algorithm = [fMove, uMove, dSliceMove,
                                rPrimeSliceMove, rMove, lSliceMove,
                                bMove, uPrimeSliceMove, bPrimeSliceMove,
                                lMove, dMove, fSliceMove];
  StickerPerm algoPerm = new StickerPerm.identity(4);
  for (StickerPerm move in algorithm) {
   algoPerm = move.applyToPermutation(algoPerm);
  }
  StickerState result = algoPerm.toState();
  StickerEdges edges = new StickerEdges(result);
  
  List<List<int>> stickers = [[-1, 5, 2], [-1, 5, 2], [4, -1, 3], [0, -1, 3],
                              [-1, 5, 1], [-1, 1, 3], [0, -1, 5], [3, -1, 5],
                              [1, 3, -1], [5, 1, -1], [5, 0, -1], [0, 4, -1],
                              [-1, 1, 2], [-1, 1, 2], [0, -1, 4], [3, -1, 4],
                              [-1, 2, 0], [-1, 2, 0], [5, -1, 3], [1, -1, 4],
                              [4, 1, -1], [4, 2, -1], [2, 4, -1], [3, 0, -1]];
  for (int i = 0; i < 24; ++i) {
    List<int> testing = edges.edgeColors(i ~/ 2, i % 2);
    List<int> correct = stickers[i];
    for (int j = 0; j < 3; ++j) {
      if (correct[j] != testing[j]) {
        print('invalid edge ${i % 2} at dedge ${i ~/ 2}');
        exit(1);
      }
    }
  }
  print('passed!');
}
