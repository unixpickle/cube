import 'package:cube/cube.dart';
import 'dart:io';

void main() {
  test3x3x3();
  test4x4x4();
}

void test3x3x3() {
  String algoStr = "R E U M D S F M' B E' L S' R' 2Uw z2 Rw' U2 L' D' F' B'" +
      " x y";
  WcaAlgorithm algo = new WcaAlgorithm.fromString(algoStr);
  StickerAlgorithm stickerAlgo = new StickerAlgorithm.fromWca(3, algo);
  StickerState state = stickerAlgo.toState();
  
  String result = '222652556' + '512365356' + '533416434' + 
      '433621411' + '541436246' + '356242111';
  for (int i = 0; i < 54; ++i) {
    if (result.codeUnitAt(i) - 0x31 != state.stickers[i]) {
      print('invalid sticker at face ${i ~/ 9} index ${i % 9}');
      exit(1);
    }
  }
  print('3x3x3 test passed!');
}

void test4x4x4() {
  String algoStr = "R F x Bw Uw y Dw Lw z Rw Fw L U D B E S M";
  WcaAlgorithm algo = new WcaAlgorithm.fromString(algoStr);
  StickerAlgorithm stickerAlgo = new StickerAlgorithm.fromWca(4, algo);
  StickerState state = stickerAlgo.toState();
  
  String result = '3265331422555345' + '6566351564666264' +
      '2241133434251514' + '2252464314526451' + '1123632531613164' +
      '3425162635142314';
  
  for (int i = 0; i < 96; ++i) {
    if (result.codeUnitAt(i) - 0x31 != state.stickers[i]) {
      print('invalid sticker at face ${i ~/ 16} index ${i % 16}');
      exit(1);
    }
  }
  print('4x4x4 test passed!');
}
