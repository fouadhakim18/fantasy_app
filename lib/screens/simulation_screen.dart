import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import 'leaderboard_screen.dart'; // Import Leaderboard Screen

class MatchSimulationScreen extends StatefulWidget {
  final Map<String, List<Player?>> selectedPlayers;

  MatchSimulationScreen({required this.selectedPlayers});

  @override
  _MatchSimulationScreenState createState() => _MatchSimulationScreenState();
}

class _MatchSimulationScreenState extends State<MatchSimulationScreen> {
  final Map<Player, Map<String, dynamic>> playerStats = {};
  bool matchSimulated = false; // Track if match is simulated

  void _simulateMatch() {
    final random = Random();

    setState(() {
      playerStats.clear();
      matchSimulated = true; // Enable FAB after simulation

      for (var position in widget.selectedPlayers.keys) {
        for (var player in widget.selectedPlayers[position]!) {
          if (player != null) {
            int goals = random.nextInt(3);
            int assists = random.nextInt(2);
            bool cleanSheet = position == "GK" || position == "DF"
                ? random.nextBool()
                : false;
            int yellowCards = random.nextInt(2);
            int redCards = random.nextInt(2) == 1 && yellowCards == 1 ? 1 : 0;

            player.updatePoints(
              goals: goals,
              assists: assists,
              cleanSheet: cleanSheet,
              yellowCards: yellowCards,
              redCards: redCards,
            );

            playerStats[player] = {
              "goals": goals,
              "assists": assists,
              "cleanSheet": cleanSheet,
              "yellowCards": yellowCards,
              "redCards": redCards,
              "totalPoints": player.points,
            };
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Match simulated! Player points updated.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
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

  Widget _buildPlayerList() {
    List<Player> allPlayers = [];

    for (var position in widget.selectedPlayers.keys) {
      for (var player in widget.selectedPlayers[position]!) {
        if (player != null) {
          allPlayers.add(player);
        }
      }
    }

    allPlayers.sort((a, b) => b.points.compareTo(a.points));

    return ListView.builder(
      itemCount: allPlayers.length,
      itemBuilder: (context, index) {
        final player = allPlayers[index];
        final stats = playerStats[player] ?? {};

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/${player.kitImageUrl}"),
              radius: 30,
              backgroundColor: Colors.transparent,
            ),
            title: Text(
              player.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "Club: ${player.club} | Position: ${player.position}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  "⚽ Goals: ${stats['goals'] ?? 0} | 🎯 Assists: ${stats['assists'] ?? 0} | 🟨 Yellow Cards: ${stats['yellowCards'] ?? 0} | 🟥 Red Cards: ${stats['redCards'] ?? 0} | ${stats['cleanSheet'] ?? false ? 'Clean Sheet ✅' : ''}",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
              ],
            ),
            trailing: Text(
              "${stats['totalPoints'] ?? 0} pts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "⚽ Match Simulation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        children: [
          // Dynamic Header Section
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.lightBlueAccent, Colors.blueAccent],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(20),
          //       bottomRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Column(
          //     children: [
          //       Text(
          //         matchSimulated
          //             ? "✅ Match Results"
          //             : "Simulate the match to see results!",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       SizedBox(height: 5),
          //       Text(
          //         "Points are updated after each match.",
          //         style: TextStyle(color: Colors.white70, fontSize: 14),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 10),
          Expanded(child: _buildPlayerGrid()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: matchSimulated ? _navigateToLeaderboard : _simulateMatch,
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.sports_soccer,
          color: Colors.green,
        ),
        label: Text(
          matchSimulated ? "View Leaderboard" : "Simulate Match",
          style: TextStyle(color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildPlayerGrid() {
    List<Player> allPlayers = [];

    // Collect all players
    for (var position in widget.selectedPlayers.keys) {
      for (var player in widget.selectedPlayers[position]!) {
        if (player != null) {
          allPlayers.add(player);
        }
      }
    }

    // Sort players by points (highest first)
    allPlayers.sort((a, b) => b.points.compareTo(a.points));

    return SingleChildScrollView(
      // Allow vertical scrolling
      child: GridView.builder(
        shrinkWrap: true, // Make GridView take only as much height as it needs
        physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
        padding: EdgeInsets.all(6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4, // Card height relative to width
        ),
        itemCount: allPlayers.length,
        itemBuilder: (context, index) {
          final player = allPlayers[index];
          final stats = playerStats[player] ?? {};

          return Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            color: Color.fromARGB(255, 230, 255, 251),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player Image (Circle Avatar)
                  Center(
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/${player.kitImageUrl}"),
                      radius: 30,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Player Name
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
                  // Club and Position
                  // Center(
                  //   child: Text(
                  //     "Club: ${player.club} | Position: ${player.position}",
                  //     overflow: TextOverflow.ellipsis,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: Colors.black54,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 2),
                  Divider(color: Colors.grey.shade500, thickness: 1),
                  // SizedBox(height: 2),
                  // Player Stats
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
                  // Total Points
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
