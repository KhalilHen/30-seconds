import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart ';

class GameScreen extends StatefulWidget {
  final List<String> teams;
  final Map<String, List<String>> players;

  const GameScreen({Key? key, required this.teams, required this.players}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> words;
  int currentTeamIndex = 0;
  int currentPlayerIndex = 0;
  int timer = 30;
  bool isGameStarted = false;
  String currentWordSet = '';
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    words = generateRandomWords();
    startCountdown();
  }

//TODO Later change this into fetch api
  List<String> generateRandomWords() {
    final allWords = [
      'apple',
      'banana',
      'cherry',
      'dog',
      'elephant',
      'flower',
      'grape',
      'house',
      'island',
      'jungle',
      'kite',
      'lemon',
      'mountain',
      'notebook',
      'ocean',
      'pencil',
      'queen',
      'river',
      'star',
      'tiger',
      'umbrella',
      'violin',
      'waterfall',
      'xylophone',
      'yacht',
      'zebra',
    ];
    final random = Random();
    return List.generate(5, (_) => allWords[random.nextInt(allWords.length)]);
  }

  void startCountdown() {
    setState(() {
      isGameStarted = false;
      timer = 5;
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 1) {
        setState(() {
          this.timer--;
        });
      } else {
        timer.cancel();
        startGameRound();
      }
    });
  }

  void startGameRound() {
    setState(() {
      isGameStarted = true;
      timer = 30;
      words = generateRandomWords();
      currentWordSet = words.join(', ');
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 1) {
        setState(() {
          this.timer--;
        });
      } else {
        timer.cancel();
        nextPlayer();
      }
    });
  }

  void nextPlayer() {
    countdownTimer?.cancel();
    setState(() {
      currentPlayerIndex++;
      if (currentPlayerIndex >= widget.players[widget.teams[currentTeamIndex]]!.length) {
        currentPlayerIndex = 0;
        currentTeamIndex++;
        if (currentTeamIndex >= widget.teams.length) {
          currentTeamIndex = 0;
        }
      }
    });
    startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTeam = widget.teams[currentTeamIndex];
    final currentPlayer = widget.players[currentTeam]![currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'),
      ),
      body: Center(
        child: isGameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Team: $currentTeam',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Player: $currentPlayer',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Time Left: $timer',
                    style: TextStyle(fontSize: 32.0, color: Colors.red),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Words: $currentWordSet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              )
            : Text(
                'Get Ready $currentPlayer Starting in   $timer...',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
