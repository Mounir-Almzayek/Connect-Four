class Board {
  static const int ROWS = 6;
  static const int COLS = 7;
  static const int EMPTY = 0;
  static const int PLAYER = 1;
  static const int BOT = 2;
  List<List<int>> board;

  Board() : board = List.generate(ROWS, (_) => List.filled(COLS, EMPTY));

  bool isValidMove(int col) {
    return col >= 0 && col < COLS && board[0][col] == EMPTY;
  }

  bool isFull() {
    for (int col = 0; col < COLS; col++) {
      if (board[0][col] == EMPTY) {
        return false;
      }
    }
    return true;
  }

  void makeMove(int col, int player) {
    if (isValidMove(col)) {
      int row = getAvailableRow(col);
      board[row][col] = player;
    }
  }

  int getAvailableRow(int col) {
    for (int row = ROWS - 1; row >= 0; row--) {
      if (board[row][col] == EMPTY) {
        return row;
      }
    }
    return -1; // This should not happen if the move is valid
  }

  bool checkWin(int player) {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        if (checkDirection(row, col, 1, 0, player) || // Horizontal
            checkDirection(row, col, 0, 1, player) || // Vertical
            checkDirection(row, col, 1, 1, player) || // Diagonal \
            checkDirection(row, col, 1, -1, player)) { // Diagonal /
          return true;
        }
      }
    }
    return false;
  }

  bool checkDirection(int row, int col, int rowDelta, int colDelta, int player) {
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


  void printBoard() {
    for (int i = 0; i < ROWS; i++) {
      print(board[i].join(' '));
    }
    print('');
  }
}
