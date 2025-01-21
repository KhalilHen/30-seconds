import 'package:flutter/material.dart';

class SetupTeamsPage extends StatefulWidget {
  @override
  _SetupTeamsPageState createState() => _SetupTeamsPageState();
}

class _SetupTeamsPageState extends State<SetupTeamsPage> {
  final List<String> teams = [];
  final Map<String, List<String>> players = {};

  final TextEditingController teamController = TextEditingController();
  final Map<String, TextEditingController> playerController = {};

  void addPlayer(String team) {
    final controller = playerController[team];
    if (controller != null && controller.text.isNotEmpty) {
      setState(() {
        players[team]?.add(controller.text.trim());
        controller.clear();
      });
    }
  }

  void addTeam() {
    if (teamController.text.isNotEmpty) {
      setState(() {
        final teamName = teamController.text.trim();
        if (!teams.contains(teamName)) teams.add(teamName);
        players[teamName] = [];
        playerController[teamName] = TextEditingController();
        teamController.clear();
      });
    }
  }

  bool canStartGame() {
    if (teams.length < 2) return false;
    for (var team in teams) {
      if ((players[team]?.length ?? 0) < 2) return false;
    }
    return true;
  }

  @override
  void dispose() {
    teamController.dispose();
    playerController.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Teams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: teamController,
              decoration: InputDecoration(
                labelText: 'Enter Team Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTeam,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a team name';
                }
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: teams.isEmpty
                  ? Center(
                      child: Text(
                        'No teams added yet. Start by adding a team!',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ExpansionTile(
                            title: Text(
                              team,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            children: [
                              if (players[team]?.isNotEmpty ?? false)
                                ...players[team]!.map(
                                  (player) => ListTile(
                                    title: Text(player),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          controller: playerController[team],
                                          decoration: InputDecoration(
                                            labelText: 'Enter Player Name',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "please enter a player name";
                                            }
                                          }),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => addPlayer(team),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}
