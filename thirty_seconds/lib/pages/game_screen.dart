import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  final List<String> teams;
  final Map<String, List<String>> players;

  const GameScreen({Key? key, required this.teams, required this.players}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> words;
  late Map<String, int> teamScores;

  int currentTeamIndex = 0;
  int currentPlayerIndex = 0;
  int timer = 30;
  bool isGameStarted = false;
  String currentWordSet = '';
  Timer? countdownTimer;
  final AudioPlayer audioPlayer = AudioPlayer(); //* Not used

  double shakeOffSet = 0.0;

  @override
  void initState() {
    super.initState();
    teamScores = {for (var team in widget.teams) team: 0};
    words = generateRandomWords();
    startCountdown();
  }

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
        // playSoundAndShake();
        showScoreDialog();
      }
    });
  }

  // void playSoundAndShake() {
  //   audioPlayer.play('assets/count-down.mp3' as Source, volume: 1.0);
  //   setState(() {
  //     shakeOffSet = 10;
  //   });
  //   Future.delayed(Duration(milliseconds: 200), () {
  //     setState(() {
  //       shakeOffSet = 0;
  //     });
  //   });
  // }

  Future<void> showScoreDialog() async {
    final currentTeam = widget.teams[currentTeamIndex];
    final currentPlayer = widget.players[currentTeam]![currentPlayerIndex];

    int guessedWords = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '$currentPlayer\'s Turn Over',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.deepPurple[800], fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How many words did $currentPlayer guess correctly?'),
              const SizedBox(height: 16),
              Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: List.generate(6, (index) {
                    return ElevatedButton(
                        onPressed: () {
                          guessedWords = index;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[600], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                  }))
            ],
          ),
        );
      },
    );

    updateScore(currentTeam, guessedWords);
    nextPlayer();
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

  void updateScore(String team, int guessedWords) {
    setState(() {
      teamScores[team] = (teamScores[team] ?? 0) + guessedWords;
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTeam = widget.teams[currentTeamIndex];
    final currentPlayer = widget.players[currentTeam]![currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Game screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      "Scoreboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.teams.map((team) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              team,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepPurple[600],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "team: ${teamScores[team]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(16)),
              isGameStarted
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
                      'Get Ready $currentPlayer Starting in $timer...',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
