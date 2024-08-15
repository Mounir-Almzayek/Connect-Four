import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/algorithm/ConnectFourAI.dart';
import '../core/algorithm/board.dart';
import 'package:connectfour/core/utils/ResponsiveHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GamePage extends StatefulWidget {
  final int maxDepth;

  GamePage({required this.maxDepth});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Board board;
  late ConnectFourAI ai;
  bool gameEnded = false;
  String message = "Player 1's turn";
  int currentPlayer = Board.PLAYER;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    board = Board();
    ai = ConnectFourAI(maxDepth: widget.maxDepth);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 20,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4D47C3),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        leadingWidth: 60,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(responsiveHelper.widthPercentage(3), responsiveHelper.heightPercentage(12), responsiveHelper.widthPercentage(3), responsiveHelper.heightPercentage(10)),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A1E1E1E),
                        offset: Offset(0, 0),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x1A1E1E1E),
                        offset: Offset(0, 3),
                        blurRadius: 3.5,
                      ),
                      BoxShadow(
                        color: Color(0x171E1E1E),
                        offset: Offset(0, 13),
                        blurRadius: 6.5,
                      ),
                      BoxShadow(
                        color: Color(0x0D1E1E1E),
                        offset: Offset(0, 29),
                        blurRadius: 9,
                      ),
                      BoxShadow(
                        color: Color(0x031E1E1E),
                        offset: Offset(0, 52),
                        blurRadius: 10.5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTapUp: (details) {
                        final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                        final localPosition =
                        renderBox.globalToLocal(details.globalPosition);

                        final double gridWidth = renderBox.size.width;

                        int col = (localPosition.dx /
                            (gridWidth / Board.COLS))
                            .floor();

                        _handleTap(col);
                      },
                      child: AspectRatio(
                        aspectRatio: Board.COLS / Board.ROWS,
                        child: Container(
                          color: Color(0xFF4D47C3),
                          child: CustomPaint(
                            painter: BoardPainter(board, responsiveHelper),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                padding: responsiveHelper.getPadding(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: _getCurrentColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: responsiveHelper.textSize(4),
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Container(
              padding: responsiveHelper.getPadding(vertical: 3),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    board = Board();
                    gameEnded = false;
                    message = "Player 1's turn";
                    currentPlayer = Board.PLAYER;
                  });
                },
                child: Icon(
                  Icons.restart_alt,
                  size: responsiveHelper.textSize(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(int col) {
    if (board.isValidMove(col) && !gameEnded) {
      setState(() {
        board.makeMove(col, currentPlayer);
        if (board.checkWin(currentPlayer)) {
          message = currentPlayer == Board.PLAYER ? "Player 1 wins!" : "Bot wins!";
          gameEnded = true;
          _updateWinsCount(); // Call the method to update wins count
        } else if (board.isFull()) {
          message = "It's a draw!";
          gameEnded = true;
        } else {
          currentPlayer = Board.BOT;
          message = "Bot's turn";
          _botMove();
        }
      });
    }
  }

  void _botMove()  {
    if (!gameEnded) {
      int bestMove = ai.minimax(board.board, ai.maxDepth, -ConnectFourAI.INF,
          ConnectFourAI.INF, true).move;
      setState(() {
        if (bestMove != -1) {
          board.makeMove(bestMove, Board.BOT);
          if (board.checkWin(Board.BOT)) {
            message = "Bot wins!";
            gameEnded = true;
          } else if (board.isFull()) {
            message = "It's a draw!";
            gameEnded = true;
          } else {
            currentPlayer = Board.PLAYER;
            message = "Player 1's turn";
          }
        }
      });
    }
  }

  void _updateWinsCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        int currentWins = (snapshot.data() as Map<String, dynamic>)['winsCount'] ?? 0;
        if(ai.maxDepth == 3) {
          transaction.update(userDoc, {'winsCount': currentWins + 1});
        }else if(ai.maxDepth == 5) {
          transaction.update(userDoc, {'winsCount': currentWins + 2});
        }
      }).catchError((error) {
        print("Failed to update wins count: $error");
      });
    }
  }

  Color _getCurrentColor() {
    if (gameEnded) {
      if (message.contains("draw")) {
        return Color(0xFF4D47C3);
      }
      return message.contains("Player 1 wins!") ? Color(0xFFBF3131) : Color(0xFFFFE17B);
    }
    return currentPlayer == Board.PLAYER ? Color(0xFFBF3131) : Color(0xFFFFE17B);
  }
}


class BoardPainter extends CustomPainter {
  final Board board;
  final ResponsiveHelper responsiveHelper;

  BoardPainter(this.board, this.responsiveHelper);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cellWidth = size.width / Board.COLS;
    final cellHeight = size.height / Board.ROWS;

    for (int row = 0; row < Board.ROWS; row++) {
      for (int col = 0; col < Board.COLS; col++) {
        final x = col * cellWidth;
        final y = row * cellHeight;

        canvas.drawCircle(
          Offset(x + cellWidth / 2, y + cellHeight / 2),
          (cellWidth / 2) - 5,
          paint..color = Colors.white,
        );

        if (board.board[row][col] == Board.PLAYER) {
          paint.color = Color(0xFFBF3131);
        } else if (board.board[row][col] == Board.BOT) {
          paint.color = Color(0xFFFFE17B);
        } else {
          continue;
        }

        canvas.drawCircle(
          Offset(x + cellWidth / 2, y + cellHeight / 2),
          (cellWidth / 2) - 8,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
