import 'Move.dart';

class ConnectFourAI {
  static const int ROWS = 6;
  static const int COLS = 7;
  static const int EMPTY = 0;
  static const int PLAYER = 1;
  static const int BOT = 2;
  static const int INF = 1000000;
  final int maxDepth;

  ConnectFourAI({required this.maxDepth});


  Move minimax(List<List<int>> board, int depth, int alpha, int beta, bool isMaximizing) {
    int bestMove = -1;
    int bestScore = isMaximizing ? -INF : INF;

    if (depth == 0 || checkWin(board, BOT) || checkWin(board, PLAYER)) {
      return Move(-1, evaluateBoard(board));
    }

    for (int col = 0; col < COLS; col++) {
      if (isValidMove(board, col)) {
        int row = getAvailableRow(board, col);
        board[row][col] = isMaximizing ? BOT : PLAYER;

        Move move = minimax(board, depth - 1, alpha, beta, !isMaximizing);
        board[row][col] = EMPTY;

        if (isMaximizing) {
          if (move.score > bestScore) {
            bestScore = move.score;
            bestMove = col;
          }
          alpha = alpha > bestScore ? alpha : bestScore;
        } else {
          if (move.score < bestScore) {
            bestScore = move.score;
            bestMove = col;
          }
          beta = beta < bestScore ? beta : bestScore;
        }

        if (beta <= alpha) {
          break;
        }
      }
    }
    return Move(bestMove, bestScore);
  }

  int evaluateBoard(List<List<int>> board) {
    int score = 0;

    if (checkWin(board, BOT)) {
      return 10000;
    }
    if (checkWin(board, PLAYER)) {
      return -10000;
    }

    score += evaluateThreats(board, BOT);
    score -= evaluateThreats(board, PLAYER);

    return score;
  }

  int evaluateThreats(List<List<int>> board, int player) {
    int score = 0;

    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        score += evaluateDirection(board, row, col, 1, 0, player);
        score += evaluateDirection(board, row, col, 0, 1, player);
        score += evaluateDirection(board, row, col, 1, 1, player);
        score += evaluateDirection(board, row, col, 1, -1, player);
      }
    }
    return score;
  }

  int evaluateDirection(List<List<int>> board, int row, int col, int rowDelta, int colDelta, int player) {
    int score = 0;
    int count = 0;
    int opponent = (player == BOT) ? PLAYER : BOT;

    for (int i = 0; i < 4; i++) {
      int r = row + i * rowDelta;
      int c = col + i * colDelta;
      if (r >= 0 && r < ROWS && c >= 0 && c < COLS) {
        if (board[r][c] == player) {
          count++;
        } else if (board[r][c] == EMPTY) {
          // Consider this as a potential move location
        } else {
          count = -1; // Break the loop as it's blocked by opponent
          break;
        }
      } else {
        count = -1; // Break the loop as it goes out of bounds
        break;
      }
    }

    if (count == 4) {
      score += 1000; // Perfect line for the player
    } else if (count == 3) {
      score += 100; // Strong threat
    } else if (count == 2) {
      score += 10; // Moderate threat
    }

    // Add evaluation for opponent
    count = 0;
    for (int i = 0; i < 4; i++) {
      int r = row + i * rowDelta;
      int c = col + i * colDelta;
      if (r >= 0 && r < ROWS && c >= 0 && c < COLS) {
        if (board[r][c] == opponent) {
          count++;
        } else if (board[r][c] == EMPTY) {
          // Consider this as a potential move location
        } else {
          count = -1; // Break the loop as it's blocked by player
          break;
        }
      } else {
        count = -1; // Break the loop as it goes out of bounds
        break;
      }
    }

    if (count == 4) {
      score -= 1000; // Perfect line for the opponent
    } else if (count == 3) {
      score -= 100; // Strong threat from opponent
    } else if (count == 2) {
      score -= 10; // Moderate threat from opponent
    }

    return score;
  }

  bool isValidMove(List<List<int>> board, int col) {
    return board[0][col] == EMPTY;
  }

  int getAvailableRow(List<List<int>> board, int col) {
    for (int row = ROWS - 1; row >= 0; row--) {
      if (board[row][col] == EMPTY) {
        return row;
      }
    }
    return -1;
  }

  bool checkWin(List<List<int>> board, int player) {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        if (checkDirection(board, row, col, 1, 0, player) || // Horizontal
            checkDirection(board, row, col, 0, 1, player) || // Vertical
            checkDirection(board, row, col, 1, 1, player) || // Diagonal \
            checkDirection(board, row, col, 1, -1, player)) { // Diagonal /
          return true;
        }
      }
    }
    return false;
  }

  bool checkDirection(List<List<int>> board, int row, int col, int rowDelta, int colDelta, int player) {
    int count = 0;
    for (int i = 0; i < 4; i++) {
      int r = row + i * rowDelta;
      int c = col + i * colDelta;
      if (r >= 0 && r < ROWS && c >= 0 && c < COLS && board[r][c] == player) {
        count++;
      } else {
        break;
      }
    }
    return count == 4;
  }
}
