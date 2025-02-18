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

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late List<String> words;
  late Map<String, int> teamScores;

  int currentTeamIndex = 0;
  int currentPlayerIndex = 0;
  int timer = 30;
  bool isGameStarted = false;
  String currentWordSet = '';
  Timer? countdownTimer;
  final AudioPlayer audioPlayer = AudioPlayer(); //* Not used

  late AnimationController shakeController;
  late Animation<double> shakeAnimation;
  bool shouldShake = false;
  bool isSoundPlaying = false;
  @override
  void initState() {
    super.initState();
    teamScores = {for (var team in widget.teams) team: 0};
    words = generateRandomWords();

    audioPlayer.setSource(AssetSource('count-down.mp3 '));

    shakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    shakeAnimation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(shakeController);
    startCountdown();
  }

  Future<void> playTimerEndSound() async {
    if (!isSoundPlaying) {
      isSoundPlaying = true;
      await audioPlayer.play(AssetSource('count-down.mp3'));
    }
  }

  Future<void> stopTimerEndSound() async {
    await audioPlayer.stop();
    isSoundPlaying = false;
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

        if (this.timer <= 3 && this.timer > 0) {
          shouldShake = true;
          shakeController.forward(from: 0);
        }
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
      shouldShake = false;
      isSoundPlaying = false;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 1) {
        setState(() {
          this.timer--;
          if (this.timer <= 3 && this.timer > 0) {
            shouldShake = true;
            shakeController.forward(from: 0);
          }
          if (this.timer <= 5 && this.timer > 0) {
            playTimerEndSound();
          } else {
            shouldShake = false;
          }
        });
      } else {
        stopTimerEndSound();
        shakeController.forward(from: 0);
        timer.cancel();
        showScoreDialog();
      }
    });
  }

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

    shakeController.dispose();
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
          child: AnimatedBuilder(
            animation: shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: shouldShake ? Offset(shakeAnimation.value, 0) : Offset.zero,
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple[200]!, Colors.deepPurple[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Scoreboard",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[900],
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.teams.map((team) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Team: $team",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Score: ${teamScores[team]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                isGameStarted
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Team: $currentTeam',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Player: $currentPlayer',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: timer <= 5 ? Colors.red[800] : Colors.deepPurple[900],
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: Text('Time Left: $timer'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Words: $currentWordSet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.deepPurple[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Get Ready $currentPlayer Starting in $timer...',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
