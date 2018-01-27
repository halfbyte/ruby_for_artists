# Data for a simple pixel font.
# How to render it:
# Find the character you need (it uses a very reduced charset).
# :width gives you the width of the character, including a spacer pixel on the right
# :data contains a bitmask for each line of the character. So, the data for a renders
# as:
#   **
#  *  *
#  ****
#  *  *
#  *  *
#

module CharFont
  CHARS = {
      'a' => {width: 5, data: [6, 9, 15, 9, 9]},
      'b' => {width: 5, data: [7, 9, 7, 9, 7]},
      'c' => {width: 5, data: [14, 1, 1, 1, 14]},
      'd' => {width: 5, data: [7, 9, 9, 9, 7]},
      'e' => {width: 5, data: [15, 1, 7, 1, 15]},
      'f' => {width: 5, data: [15, 1, 7, 1, 1]},
      'g' => {width: 5, data: [14, 1, 13, 9, 6]},
      'h' => {width: 5, data: [9, 9, 15, 9, 9]},
      'i' => {width: 4, data: [7, 2, 2, 2, 7]},
      'j' => {width: 5, data: [15, 8, 8, 9, 6]},
      'k' => {width: 5, data: [9, 5, 3, 5, 9]},
      'l' => {width: 5, data: [1, 1, 1, 1, 15]},
      'm' => {width: 6, data: [10, 21, 17, 17, 17]},
      'n' => {width: 5, data: [9, 11, 13, 9, 9]},
      'o' => {width: 5, data: [6, 9, 9, 9, 6]},
      'p' => {width: 5, data: [7, 9, 7, 1, 1]},
      'q' => {width: 5, data: [6, 9, 9, 9, 14]},
      'r' => {width: 5, data: [7, 9, 7, 9, 9]},
      's' => {width: 5, data: [14, 1, 6, 8, 7]},
      't' => {width: 4, data: [7, 2, 2, 2, 2]},
      'u' => {width: 5, data: [9, 9, 9, 9, 6]},
      'v' => {width: 5, data: [9, 9, 9, 6, 6]},
      'w' => {width: 6, data: [17, 17, 21, 21, 10]},
      'x' => {width: 5, data: [9, 9, 6, 9, 9]},
      'y' => {width: 5, data: [9, 9, 14, 8, 7]},
      'z' => {width: 5, data: [15, 4, 2, 1, 15]},
      '0' => {width: 5, data: [6, 9, 13, 11, 6]},
      '1' => {width: 4, data: [2, 3, 2, 2, 7]},
      '2' => {width: 5, data: [6, 9, 4, 2, 15]},
      '3' => {width: 4, data: [3, 4, 2, 4, 3]},
      '4' => {width: 5, data: [5, 5, 15, 4, 4]},
      '5' => {width: 5, data: [15, 1, 7, 8, 7]},
      '6' => {width: 5, data: [14, 1, 7, 9, 6]},
      '7' => {width: 5, data: [15, 8, 4, 2, 2]},
      '8' => {width: 5, data: [6, 9, 6, 9, 6]},
      '9' => {width: 5, data: [6, 9, 14, 8, 7]},
      ' ' => {width: 2, data: [0, 0, 0, 0, 0]}
  }

end
