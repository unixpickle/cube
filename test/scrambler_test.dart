import 'package:cube/cube.dart';
import 'dart:math';
import 'dart:io';

class NumRandom implements Random {
  final List<int> numbers;
  int cur = 0;
  
  NumRandom(this.numbers);
  
  int nextInt(int max) {
    int res = numbers[cur];
    cur = (cur + 1) % numbers.length;
    return res % max;
  }
  
  bool nextBool() {
    throw new UnsupportedError('NumRandom cannot generate a boolean.');
  }
  
  double nextDouble() {
    throw new UnsupportedError('NumRandom cannot generate a double.');
  }
}

void main() {
  test4x4x4();
}

void test4x4x4() {
  NumRandom r = new NumRandom([0, 0, 0, 1, 0, 2, 7, 13, 29, 35, 21, 18, 8,
                               9, 15, 10, 11, 2, 19, 31]);
  WcaAlgorithm result = generateWCAScramble(4, 20, rand: r);
  String expected = "F Fw B Bw2 U F' Bw2 D2 L' F' R D B' U D Bw2 U' F' Dw2 Lw2";
  if (result.toString() != expected) {
    print('unexpected 4x4x4 scramble: $result');
    exit(1);
  }
  print('4x4x4 scramble passed');
}
