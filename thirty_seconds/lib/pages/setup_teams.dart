import 'package:flutter/material.dart';
import 'package:thirty_seconds/pages/start_game_overview_screen.dart';

class SetupTeamsPage extends StatefulWidget {
  @override
  _SetupTeamsPageState createState() => _SetupTeamsPageState();
}

class _SetupTeamsPageState extends State<SetupTeamsPage> {
  final List<String> teams = [];
  final Map<String, List<String>> players = {};
  final formKey = GlobalKey<FormState>();
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
    final teamName = teamController.text.trim();

    if (teams.contains(teamName)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Team already exists"),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ));
      return;
    }
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
        title: Text(
          'Pick Your Teams',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: teamController,
                decoration: InputDecoration(
                  labelText: 'Enter Team Name',
                  labelStyle: TextStyle(color: Colors.deepPurple[700]),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.deepPurple[200]!,
                      )),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addTeam,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: teams.isEmpty
                    ? Center(
                        child: Text(
                          'No teams added yet. Start by adding a team!',
                          style: TextStyle(fontSize: 16.0, color: Colors.deepPurple[300], fontStyle: FontStyle.italic),
                        ),
                      )
                    : ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          final team = teams[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                team,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                              children: [
                                if (players[team]?.isNotEmpty ?? false)
                                  ...players[team]!.map(
                                    (player) => ListTile(
                                      title: Text(
                                        player,
                                        style: TextStyle(color: Colors.deepPurple[600]),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            players[team]?.remove(player);
                                          });
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red[400]),
                                      ),
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
                                              labelStyle: TextStyle(color: Colors.deepPurple[700]),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.deepPurple[200]!)),
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
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: canStartGame()
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartGamePage(
                              teams: teams,
                              players: players,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[600],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: Text(
                  canStartGame() ? "Submit your teams" : "Cannot Start Game yet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
