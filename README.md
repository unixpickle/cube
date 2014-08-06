# Abstract

The Rubik's Cube is a well-known puzzle. However, it is not the only twisty puzzle in its category. The Rubik's cube is simply a 3x3x3 cuboid&ndash;a 6-sided twisty puzzle with stickers of 6 different colors. Other cubic cuboids are manufactured and sold in the U.S. and in other countries. While the 3x3x3 is still the most popular of these cuboids, the 2x2x2 through 7x7x7 are common as well.

This API provides a way for a program to read, manipulate, and output cubic cuboids. It can be used to generate scrambles, compute solutions, and process other information about positions on cubic cuboids.

# Usage

So far, I have created a `StickerState` class to represent a cube's state and a `StickerPermutation` class to represent an algorithm's affect on a cube's state. Additionally, the faces of a `StickerState` can be processed as `Face` objects.

# TODO

The `StickerPermutation` class handles the hardest-to-implement part of the entire API: move-to-permutation translation. On top of `StickerPermutation`, I plan to layer additional tools to parse algorithms and use WCA standard moves.

Here's my TODO list:

 * Create 4x4x4 `StickerPermutation` test
 * Create test for `Face` object
 * Create `StickerMove` class with `axis` attribute
   * Need a `StickerMove.wcaMoves(int size)` method
 * Create `generateScramble` method
