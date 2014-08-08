/**
 * A library for computational manipulation of the Rubik's Cube or cubes of
 * other sizes.
 */
library cube;

import 'dart:async';
import 'dart:math';

part 'src/abstract/cube_state.dart';
part 'src/abstract/permutation.dart';
part 'src/abstract/move.dart';
part 'src/abstract/edges.dart';

part 'src/stickers/sticker_state.dart';
part 'src/stickers/sticker_perm.dart';
part 'src/stickers/sticker_edges.dart';
part 'src/stickers/sticker_move.dart';
part 'src/stickers/sticker_algorithm.dart';
part 'src/stickers/sticker_eoline_solver.dart';
part 'src/stickers/face.dart';

part 'src/algorithm.dart';

part 'src/choose_map.dart';
part 'src/heuristic_3x3x3.dart';
part 'src/wca_move.dart';
part 'src/wca_algorithm.dart';
part 'src/notation_error.dart';
part 'src/solvers/solver.dart';
part 'src/solvers/async_solver.dart';
part 'src/solvers/eoline_solver.dart';
