import 'package:cube/cube.dart';
import 'dart:io';

void main() {
  testRandom();
}

void testRandom() {
  var fMove = new StickerPerm.faceTurn(2, 0);
  var bMove = new StickerPerm.faceTurn(2, 1);
  var uMove = new StickerPerm.faceTurn(2, 2);
  var dMove = new StickerPerm.faceTurn(2, 3);
  var rMove = new StickerPerm.faceTurn(2, 4);
  var lMove = new StickerPerm.faceTurn(2, 5);
  
  // algorithm: F D B R F R U D R F B L F R L2
  
  List<StickerPerm> algorithm = [fMove, dMove, bMove, rMove, fMove, rMove,
                                 uMove, dMove, rMove, fMove, bMove, lMove,
                                 fMove, rMove, lMove, lMove];
  StickerPerm algoPerm = new StickerPerm.identity(2);
  for (StickerPerm move in algorithm) {
    algoPerm = move.applyToPermutation(algoPerm);
  }
  StickerState result = algoPerm.toState();
  Corners corners = result.corners;
  
  List<int> physicalPieces = [2, 0, 4, 7, 6, 3, 1, 5];
  for (int i = 0; i < 8; ++i) {
    if (physicalPieces[i] != corners.readCorner(i)) {
      print('invalid corner piece at index $i');
      exit(1);
    }
  }
  
  List<int> yOrientations = [0, 1, 2, 2, 0, 1, 1, 1];
  List<int> xOrientations = [1, 2, 1, 0, 1, 0, 2, 2];
  List<int> zOrientations = [2, 0, 0, 1, 2, 2, 0, 0];
  List<List<int>> orientations = [xOrientations, yOrientations, zOrientations];
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 8; ++j) {
      if (orientations[i][j] != corners.readOrientation(j, i)) {
        print('invalid corner orientation axis $i slot $j');
        exit(1);
      }
    }
  }
  
  print('corner test passed!');
}