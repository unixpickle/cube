import 'package:cube/cube.dart';
import 'dart:io';

class SearchState {
  final int depth;
  final StickerState state;
  
  SearchState(this.depth, this.state);
  
  int hashEO(int axis) {
    return new Heuristic3x3x3(state.edges).hashEO(axis);
  }
  
  int hashEOAndEdge(int axis, int edge) {
    return new Heuristic3x3x3(state.edges).hashEOAndEdge(axis, edge);
  }
  
  int hashEOLine() {
    return new Heuristic3x3x3(state.edges).hashEOLineEdges();
  }
}

void main() {
  List<int> values = generateBigHeuristic(2);
  print('$values');
  
  List<int> xHeuristic = generateHeuristic(0);
  for (int i = 0; i < 2048; ++i) {
    if (xHeuristic[i] != Heuristic3x3x3.xEOHeuristic[i]) {
      print('mismatching EO heuristic for hash $i on X axis');
      exit(1);
    }
  }
  print('X EO heuristic passed');
  
  List<int> yHeuristic = generateHeuristic(1);
  for (int i = 0; i < 2048; ++i) {
    if (yHeuristic[i] != Heuristic3x3x3.yEOHeuristic[i]) {
      print('mismatching EO heuristic for hash $i on Y axis');
      exit(1);
    }
  }
  print('Y EO heuristic passed');
  
  List<int> zHeuristic = generateHeuristic(2);
  for (int i = 0; i < 2048; ++i) {
    if (zHeuristic[i] != Heuristic3x3x3.zEOHeuristic[i]) {
      print('mismatching EO heuristic for hash $i on Z axis');
      exit(1);
    }
  }
  print('Z EO heuristic passed');
  
  List<int> edgeHeuristic = generateLineHeuristic();
  for (int i = 0; i < 528; ++i) {
    if (edgeHeuristic[i] != Heuristic3x3x3.eoLineHeuristic[i]) {
      print('mismatching EOLine heuristic at index $i');
      exit(1);
    }
  }
  print('line-edge heuristic passed');
}

List<StickerPerm> generateMoves() {
  List<StickerPerm> result = [];
  
  StickerPerm fTurn = new StickerPerm.faceTurn(3, 0);
  StickerPerm bTurn = new StickerPerm.faceTurn(3, 1);
  StickerPerm uTurn = new StickerPerm.faceTurn(3, 2);
  StickerPerm dTurn = new StickerPerm.faceTurn(3, 3);
  StickerPerm rTurn = new StickerPerm.faceTurn(3, 4);
  StickerPerm lTurn = new StickerPerm.faceTurn(3, 5);
  List<StickerPerm> basis = [fTurn, bTurn, uTurn, dTurn, rTurn, lTurn];
  for (int i = 0; i < 3; ++i) {
    for (int x = 0; x < 6; ++x) {
      StickerPerm res = basis[x];
      for (int j = 0; j < i; ++j) {
        res = basis[x].applyToPermutation(res);
      }
      result.add(res);
    }
  }
  
  return result;
}

List<int> generateHeuristic(int axis) {
  List<int> result = new List<int>.filled(2048, -1);
  List<StickerPerm> moves = generateMoves();
  List<SearchState> nodes = [new SearchState(0, new StickerState.identity(3))];
  
  while (nodes.length != 0) {
    SearchState node = nodes.first;
    if (node.depth > 7) {
      break;
    }
    nodes.removeAt(0);
    if (result[node.hashEO(axis)] != -1) continue;
    result[node.hashEO(axis)] = node.depth;
    
    if (node.depth == 7) continue;
    for (StickerPerm perm in moves) {
      SearchState newNode = new SearchState(node.depth + 1,
          perm.applyToState(node.state));
      if (result[newNode.hashEO(axis)] != -1) continue;
      nodes.add(newNode);
    }
  }
  
  for (int i = 0; i < 2048; ++i) {
    assert(result[i] != -1);
  }
  
  return result;
}

List<int> generateLineHeuristic() {
  List<int> result = new List<int>.filled(528, -1);
  List<StickerPerm> moves = generateMoves();
  List<SearchState> nodes = [new SearchState(0, new StickerState.identity(3))];
  
  int maxDepth = 5;
  
  while (nodes.length != 0) {
    SearchState node = nodes.first;
    if (node.depth > maxDepth) {
      break;
    }
    nodes.removeAt(0);
    if (result[node.hashEOLine()] != -1) continue;
    result[node.hashEOLine()] = node.depth;
    
    if (node.depth == maxDepth) continue;
    for (StickerPerm perm in moves) {
      SearchState newNode = new SearchState(node.depth + 1,
          perm.applyToState(node.state));
      if (result[newNode.hashEOLine()] != -1) continue;
      nodes.add(newNode);
    }
  }
  
  for (int i = 0; i < 528; ++i) {
    assert(result[i] != -1);
  }
  return result;
}

List<int> generateBigHeuristic(int edge) {
  List<int> result = new List<int>.filled(24576, -1);
  List<StickerPerm> moves = generateMoves();
  List<SearchState> nodes = [new SearchState(0, new StickerState.identity(3))];
  
  int maxDepth = 9;
  
  while (nodes.length != 0) {
    SearchState node = nodes.first;
    if (node.depth > maxDepth) {
      break;
    }
    nodes.removeAt(0);
    if (result[node.hashEOAndEdge(2, edge)] != -1) continue;
    result[node.hashEOAndEdge(2, edge)] = node.depth;
    
    if (node.depth == maxDepth) continue;
    for (StickerPerm perm in moves) {
      SearchState newNode = new SearchState(node.depth + 1,
          perm.applyToState(node.state));
      if (result[newNode.hashEOAndEdge(2, edge)] != -1) continue;
      nodes.add(newNode);
    }
  }
  
  for (int i = 0; i < 24576; ++i) {
    assert(result[i] != -1);
  }
  return result;
}
