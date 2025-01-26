import 'package:flutter/material.dart';
import 'package:thirty_seconds/pages/game_screen.dart';

class StartGamePage extends StatelessWidget {
  final Map<String, List<String>> players;
  final List<String> teams;

  const StartGamePage({Key? key, required this.teams, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team overview'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teams overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (players[team]?.isNotEmpty ?? false)
                                ...players[team]!.map(
                                  (player) => Text(
                                    '• $player',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                            ],
                          ),
                        );
                      })),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(teams: teams, players: players),
                      ),
                    );
                  },
                  child: Text(
                    'Start Game',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
