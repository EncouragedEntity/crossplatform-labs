// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobile_app/presentation/widgets/circle_image.dart';

import '../widgets/cross_image.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<Widget>> board =
      List.generate(3, (_) => List.filled(3, Container()));

  bool isCircleMove = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isCircleMove ? "Circle's turn" : "Cross's turn",
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          Column(
            children: List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) {
                  return InkWell(
                    onTap: () {
                      _onTileTap(row, col);
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: board[row][col],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }

  void _onTileTap(int row, int col) {
    if (board[row][col] is Container) {
      setState(() {
        board[row][col] =
            isCircleMove ? const CircleImage() : const CrossImage();
        isCircleMove = !isCircleMove;
        _checkForWinner();
      });
    }
  }

  void _checkForWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] is! Container) {
        _showWinnerDialog(board[i][0]);
        return;
      }
    }

    for (int i = 0; i < 3; i++) {
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] is! Container) {
        _showWinnerDialog(board[0][i]);
        return;
      }
    }

    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] is! Container) {
      _showWinnerDialog(board[0][0]);
      return;
    }

    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] is! Container) {
      _showWinnerDialog(board[0][2]);
      return;
    }

    if (!board.any((row) => row.any((cell) => cell is Container))) {
      _showDrawDialog();
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, Container()));
      isCircleMove = false;
    });
  }

  void _showWinnerDialog(Widget winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('${winner is CircleImage ? "Circles" : "Cross"} wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('It\'s a draw!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
