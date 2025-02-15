import 'package:flutter/material.dart';
import '../models/player.dart';
import 'leaderboard_screen.dart';
import 'dart:math';

class MatchSimulationScreen extends StatefulWidget {
  final Map<String, List<Player?>> selectedPlayers;

  MatchSimulationScreen({required this.selectedPlayers});

  @override
  _MatchSimulationScreenState createState() => _MatchSimulationScreenState();
}

class _MatchSimulationScreenState extends State<MatchSimulationScreen> {
  final Map<Player, Map<String, dynamic>> playerStats = {};
  bool matchSimulated = false;
  final Random _random = Random();

  // Simulation probabilities
  final Map<String, Map<String, double>> _eventProbabilities = {
    'FW': {
      'goalProb': 0.4,
      'assistProb': 0.3,
      'yellowCardProb': 0.1,
      'redCardProb': 0.02,
    },
    'MF': {
      'goalProb': 0.2,
      'assistProb': 0.4,
      'yellowCardProb': 0.15,
      'redCardProb': 0.02,
    },
    'DF': {
      'goalProb': 0.1,
      'assistProb': 0.2,
      'yellowCardProb': 0.2,
      'redCardProb': 0.03,
    },
    'GK': {
      'goalProb': 0.01,
      'assistProb': 0.05,
      'yellowCardProb': 0.05,
      'redCardProb': 0.01,
    },
  };

  void _simulateMatch() {
    bool hasCleanSheet =
        _random.nextDouble() > 0.6; // 40% chance of clean sheet

    widget.selectedPlayers.forEach((position, players) {
      players.forEach((player) {
        if (player != null) {
          _simulatePlayerEvents(player, hasCleanSheet);
        }
      });
    });

    setState(() {
      matchSimulated = true;
    });
  }

  void _simulatePlayerEvents(Player player, bool hasCleanSheet) {
    final probs =
        _eventProbabilities[player.position] ?? _eventProbabilities['MF']!;

    int goals = 0;
    int assists = 0;
    int yellowCards = 0;
    int redCards = 0;

    // Simulate goals
    while (_random.nextDouble() < probs['goalProb']!) {
      goals++;
    }

    // Simulate assists
    while (_random.nextDouble() < probs['assistProb']!) {
      assists++;
    }

    // Simulate cards
    if (_random.nextDouble() < probs['yellowCardProb']!) {
      yellowCards = 1;
    }

    if (_random.nextDouble() < probs['redCardProb']!) {
      redCards = 1;
      yellowCards = 0; // Reset yellow card if red card is given
    }

    _updatePlayerStats(
      player,
      goals: goals,
      assists: assists,
      yellowCards: yellowCards,
      redCards: redCards,
      cleanSheet:
          hasCleanSheet && (player.position == "GK" || player.position == "DF"),
    );
  }

  void _showEventDialog(Player player) {
    bool hasGoal = false;
    bool hasAssist = false;
    bool hasYellowCard = false;
    bool hasRedCard = false;
    bool hasCleanSheet = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Match Events for ${player.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: Text('Goal Scored (+5 points)'),
                      value: hasGoal,
                      onChanged: (bool? value) {
                        setState(() => hasGoal = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Assist (+3 points)'),
                      value: hasAssist,
                      onChanged: (bool? value) {
                        setState(() => hasAssist = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Yellow Card (-2 points)'),
                      value: hasYellowCard,
                      onChanged: (bool? value) {
                        setState(() => hasYellowCard = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Red Card (-5 points)'),
                      value: hasRedCard,
                      onChanged: (bool? value) {
                        setState(() => hasRedCard = value ?? false);
                      },
                    ),
                    if (player.position == "GK" || player.position == "DF")
                      CheckboxListTile(
                        title: Text('Clean Sheet (+4 points)'),
                        value: hasCleanSheet,
                        onChanged: (bool? value) {
                          setState(() => hasCleanSheet = value ?? false);
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    _updatePlayerStats(
                      player,
                      goals: hasGoal ? 1 : 0,
                      assists: hasAssist ? 1 : 0,
                      yellowCards: hasYellowCard ? 1 : 0,
                      redCards: hasRedCard ? 1 : 0,
                      cleanSheet: hasCleanSheet,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updatePlayerStats(
    Player player, {
    required int goals,
    required int assists,
    required int yellowCards,
    required int redCards,
    required bool cleanSheet,
  }) {
    setState(() {
      // Retrieve existing stats or initialize if not present
      final existingStats = playerStats[player] ??
          {
            "goals": 0,
            "assists": 0,
            "yellowCards": 0,
            "redCards": 0,
            "cleanSheet": false,
            "totalPoints": 0,
          };

      // Accumulate new stats with existing ones
      existingStats["goals"] += goals;
      existingStats["assists"] += assists;
      existingStats["yellowCards"] += yellowCards;
      existingStats["redCards"] += redCards;
      existingStats["cleanSheet"] = cleanSheet || existingStats["cleanSheet"];

      // Calculate new total points
      int totalPoints = existingStats["goals"] * 5 +
          existingStats["assists"] * 3 +
          (existingStats["cleanSheet"] ? 4 : 0) -
          existingStats["yellowCards"] * 2 -
          existingStats["redCards"] * 5;
      existingStats["totalPoints"] = totalPoints;

      // Update player's points and stats map
      player.points = totalPoints;
      playerStats[player] = existingStats;

      matchSimulated = true;
    });
  }

  void _navigateToLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LeaderboardScreen(selectedPlayers: widget.selectedPlayers),
      ),
    );
  }

  void _resetSimulation() {
    setState(() {
      playerStats.clear();
      widget.selectedPlayers.forEach((position, players) {
        players.forEach((player) {
          if (player != null) {
            player.resetPoints();
          }
        });
      });
      matchSimulated = false;
    });
  }

  Widget _buildPlayerGrid() {
    List<Player> allPlayers = [];
    for (var position in widget.selectedPlayers.keys) {
      for (var player in widget.selectedPlayers[position]!) {
        if (player != null) {
          allPlayers.add(player);
        }
      }
    }

    allPlayers.sort((a, b) => b.points.compareTo(a.points));

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: allPlayers.length,
        itemBuilder: (context, index) {
          final player = allPlayers[index];
          final stats = playerStats[player] ?? {};

          return GestureDetector(
            onTap: () => _showEventDialog(player),
            child: Card(
              margin: EdgeInsets.all(8),
              elevation: 5,
              color: Color.fromARGB(255, 209, 251, 242),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/${player.kitImageUrl}"),
                        radius: 30,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        player.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey.shade500, thickness: 1),
                    Text(
                      "⚽ Goals: ${stats['goals'] ?? 0} | 🎯 Assists: ${stats['assists'] ?? 0}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      "🟨 Yellow: ${stats['yellowCards'] ?? 0} | 🟥 Red: ${stats['redCards'] ?? 0}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                      ),
                    ),
                    stats['cleanSheet'] == true
                        ? Text(
                            "✅ Clean Sheet",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          )
                        : Text(
                            "❌ No Clean Sheet",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "${stats['totalPoints'] ?? 0} pts",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "⚽ Match Events",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetSimulation,
            tooltip: 'Reset Simulation',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!matchSimulated)
                  ElevatedButton.icon(
                    onPressed: _simulateMatch,
                    icon: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Auto-Simulate Match",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      // primary: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: _buildPlayerGrid()),
        ],
      ),
      floatingActionButton: matchSimulated
          ? FloatingActionButton.extended(
              onPressed: _navigateToLeaderboard,
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.leaderboard,
                color: Colors.green,
              ),
              label: Text(
                "View Leaderboard",
                style: TextStyle(color: Colors.green),
              ),
            )
          : null,
    );
  }
}
