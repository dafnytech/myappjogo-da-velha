import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(JogoDaVelhaApp());
}

class JogoDaVelhaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JogoDaVelhaPage(),
    );
  }
}

class JogoDaVelhaPage extends StatefulWidget {
  @override
  _JogoDaVelhaPageState createState() => _JogoDaVelhaPageState();
}

class _JogoDaVelhaPageState extends State<JogoDaVelhaPage> {
  List<String> _board = List.filled(9, "");
  String _currentPlayer = "X";
  bool _vsComputer = false;
  bool _gameOver = false;
  String _winner = "";

  void _resetGame() {
    setState(() {
      _board = List.filled(9, "");
      _currentPlayer = "X";
      _gameOver = false;
      _winner = "";
    });
  }

  void _makeMove(int index) {
    if (_board[index] == "" && !_gameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        if (_checkWinner(_currentPlayer)) {
          _gameOver = true;
          _winner = "$_currentPlayer venceu!";
        } else if (!_board.contains("")) {
          _gameOver = true;
          _winner = "Empate!";
        } else {
          _currentPlayer = _currentPlayer == "X" ? "O" : "X";
          if (_vsComputer && _currentPlayer == "O") {
            _computerMove();
          }
        }
      });
    }
  }

  void _computerMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == "") availableMoves.add(i);
    }
    if (availableMoves.isNotEmpty) {
      int move = availableMoves[Random().nextInt(availableMoves.length)];
      _makeMove(move);
    }
  }

  bool _checkWinner(String player) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (var condition in winConditions) {
      if (_board[condition[0]] == player &&
          _board[condition[1]] == player &&
          _board[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _gameOver ? _winner : 'Vez de $_currentPlayer',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 400),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Adicionado para evitar rolagem
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _makeMove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.blue.shade50,
                    ),
                    child: Center(
                      child: Text(
                        _board[index],
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reiniciar Jogo'),
          ),
          SwitchListTile(
            title: Text('Jogar contra o Computador'),
            value: _vsComputer,
            onChanged: (value) {
              setState(() {
                _vsComputer = value;
                _resetGame();
              });
            },
          )
        ],
      ),
    );
  }
}