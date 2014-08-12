part of cube;

/**
 * Represents the corners of a cube. The corners for any cube follow the same
 * format, so this is size-independent.
 * 
 * Corners are indexed in an easy way. A corner index is represented as the
 * number with the binary digits XYZ. If X is one, the corner is on the right
 * side of the cube, otherwise it's on the left. If Y is one, the corner is on
 * the top of the cube, otherwise it's on the bottom. If Z is one, the corner
 * is in the front of the cube, otherwise it's in the back.
 */
abstract class Corners {
  /**
   * Returns the physical slot from which a certain corner originated. This is
   * similar to [Edges.readEdge].
   */
  int readCorner(int slot);
  
  /**
   * Return's information describing the orientation of the corner in a [slot].
   * 
   * A corner's orientation can be defined as the direction in which the white
   * or yellow sticker is facing (that is, x, y, or z). In this case, white or
   * yellow is the color that was originally facing in the y direction. The same
   * definition scheme works for orange/red, and blue/green.
   * 
   * Pass [origAxis] to specify the pair of colors to look at. For instance, a
   * value of 1 corresponds to the y-axis which specifies white/yellow stickers.
   * 
   * The return value indicates the direction in which the color indicated by
   * [origAxis] is currently facing. For example, if you twist the
   * top-right-front corner clockwise, it's y color will now be facing in the x
   * direction, so `axisOfColor(7, 1)` will return `0`.
   */
  int readOrientation(int slot, int origAxis);
}
