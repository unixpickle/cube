import 'package:cube/cube.dart';
import 'dart:io';

void main() {
  test3x3x3();
}

void test3x3x3() {
  var fMove = new StickerPermutation.faceTurn(3, 0);
  var bMove = new StickerPermutation.faceTurn(3, 1);
  var uMove = new StickerPermutation.faceTurn(3, 2);
  var dMove = new StickerPermutation.faceTurn(3, 3);
  var rMove = new StickerPermutation.faceTurn(3, 4);
  var lMove = new StickerPermutation.faceTurn(3, 5);
  var mMove = new StickerPermutation.slice(3, 0, 1);
  var eMove = new StickerPermutation.slice(3, 1, 1);
  var sMove = new StickerPermutation.slice(3, 2, 1);
  
  // algorithm: F D B R M R U E L D F B S R U M
  // (tested on an actual Rubik's cube and entered in)
  
  List<StickerPermutation> algorithm = [fMove, dMove, bMove, rMove, mMove,
                                        rMove, uMove, eMove, lMove, dMove,
                                        fMove, bMove, sMove, rMove, uMove,
                                        mMove];
  StickerPermutation algoPerm = new StickerPermutation.identity(3);
  for (StickerPermutation move in algorithm) {
    algoPerm = move.applyToPermutation(algoPerm);
  }
  StickerState result = algoPerm.toState();
  var expected = [4, 3, 3, 1, 3, 5, 4, 0, 0, 4, 1, 5, 0, 2, 5, 2, 0, 5, 3, 3, 1,
                  4, 4, 4, 0, 5, 5, 1, 4, 2, 5, 5, 4, 2, 3, 4, 0, 3, 2, 1, 1, 2,
                  5, 2, 0, 1, 1, 3, 2, 0, 2, 1, 0, 3];
  for (int i = 0; i < 54; i++) {
    if (expected[i] != result.stickers[i]) {
      print('3x3x3 test failed!');
      exit(1);
    }
  }
  print('3x3x3 test succeeded!');
}
