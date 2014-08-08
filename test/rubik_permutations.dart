import 'package:cube/cube.dart';
import 'dart:io';

void main() {
  test3x3x3();
  test4x4x4();
}

void test3x3x3() {
  var fMove = new StickerPerm.faceTurn(3, 0);
  var bMove = new StickerPerm.faceTurn(3, 1);
  var uMove = new StickerPerm.faceTurn(3, 2);
  var dMove = new StickerPerm.faceTurn(3, 3);
  var rMove = new StickerPerm.faceTurn(3, 4);
  var lMove = new StickerPerm.faceTurn(3, 5);
  var mMove = new StickerPerm.slice(3, 0, 1);
  var eMove = new StickerPerm.slice(3, 1, 1);
  var sMove = new StickerPerm.slice(3, 2, 1);
  
  // algorithm: F D B R M R U E L D F B S R U M
  // (tested on an actual Rubik's cube and entered in)
  
  List<StickerPerm> algorithm = [fMove, dMove, bMove, rMove, mMove,
                                 rMove, uMove, eMove, lMove, dMove,
                                 fMove, bMove, sMove, rMove, uMove,
                                 mMove];
  StickerPerm algoPerm = new StickerPerm.identity(3);
  for (StickerPerm move in algorithm) {
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

void test4x4x4() {
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
  String expected = '2335666463344241' +
                    '3331515554445114' +
                    '4222424124653661' +
                    '1623313123156332' +
                    '3166125452516434' +
                    '6265265462112555';
  for (int i = 0; i < 96; ++i) {
    if (result.stickers[i] != expected.codeUnitAt(i) - 0x31) {
      print('invalid sticker at face ${i ~/ 16} index ${i % 16}');
      exit(1);
    }
  }
  print('4x4x4 test succeeded!');
}
