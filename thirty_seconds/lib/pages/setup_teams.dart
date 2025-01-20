import 'package:flutter/material.dart';

class SetupTeamsPage extends StatefulWidget {
  @override
  _SetupTeamsPageState createState() => _SetupTeamsPageState();
}

class _SetupTeamsPageState extends State<SetupTeamsPage> {
  final List<String> teams = [];
  final Map<String, List<String>> players = {};

  final TextEditingController teamController = TextEditingController();
  final TextEditingController playerController = TextEditingController();

  void addPlayer(String team) {
    if (playerController.text.isNotEmpty) {
      setState(() {
        players[team]?.add(playerController.text);
        playerController.clear();
      });
    }
  }

  void addTeam() {
    if (teamController.text.isNotEmpty) {
      setState(() {
        teams.add(teamController.text);
        players[teamController.text] = [];
        teamController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Teams and Players'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: teamController,
              decoration: InputDecoration(
                labelText: 'Team Name',
                hintText: 'Team 1',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTeam,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return ExpansionTile(
                    title: Text(team),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: players[team]?.length ?? 0,
                        itemBuilder: (context, playerIndex) {
                          return ListTile(
                            title: Text(players[team]![playerIndex]),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: playerController,
                                decoration: InputDecoration(
                                  labelText: 'Player Name',
                                  hintText: 'Player 1',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => addPlayer(team),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
