import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/player.dart';

class LeaderboardScreen extends StatelessWidget {
  final Map<String, List<Player?>> selectedPlayers;

  LeaderboardScreen({required this.selectedPlayers});

  int _calculateUserTotalPoints() {
    int totalPoints = 0;
    for (var position in selectedPlayers.keys) {
      for (var player in selectedPlayers[position]!) {
        if (player != null) {
          totalPoints += player.points;
        }
      }
    }
    return totalPoints;
  }

  @override
  Widget build(BuildContext context) {
    int userPoints = _calculateUserTotalPoints();
    final size = MediaQuery.of(context).size;

    List<Map<String, dynamic>> users = [
      {
        "name": "Adison Press",
        "points": 74,
        "avatar": "assets/avatar1.png",
        "flag": "🇺🇸"
      },
      {
        "name": "Ruben Geidt",
        "points": 20,
        "avatar": "assets/avatar2.png",
        "flag": "🇩🇪"
      },
      {
        "name": "Jakob L",
        "points": 23,
        "avatar": "assets/avatar3.png",
        "flag": "🇬🇧"
      },
      {
        "name": "Madelyn Dias",
        "points": 56,
        "avatar": "assets/avatar4.png",
        "flag": "🇮🇳"
      },
      {
        "name": "Zain Vaccaro",
        "points": 31,
        "avatar": "assets/avatar5.png",
        "flag": "🇮🇹"
      },
      {
        "name": "You",
        "points": userPoints,
        "avatar": "assets/your_avatar.png",
        "flag": "🌍"
      },
    ];

    users.sort((a, b) => b["points"].compareTo(a["points"]));

    return Scaffold(
      backgroundColor: Color(0xFF6B4EFF),
      appBar: AppBar(
        title: Text(
          "🏆 Leaderboard",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green, // Deep forest green
                  Colors.green, // Light mint green
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header Section
                  // _buildHeader(),

                  // Podium Section with ScrollView
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: size.height * 0.425, // Responsive height
                    child: SingleChildScrollView(
                      child: _buildPodiumSection(users.sublist(0, 3)),
                    ),
                  ),

                  // List Section
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Handle for the bottom sheet
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: _buildPlayersList(users.sublist(3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {},
              ),
              // Expanded(
              //   child: Text(
              //     "Leaderboard",
              //     style: GoogleFonts.poppins(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 16),
          // Container(
          //   padding: EdgeInsets.all(4),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.15),
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          //   child: Row(
          //     children: [
          //       _buildTabButton("Weekly", true),
          //       _buildTabButton("All Time", false),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.green : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumSection(List<Map<String, dynamic>> topThree) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumPosition(topThree[1], 2, 140),
              _buildPodiumPosition(topThree[0], 1, 180),
              _buildPodiumPosition(topThree[2], 3, 120),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPosition(
      Map<String, dynamic> user, int position, double height) {
    final bool isFirst = position == 1;
    final scale = isFirst ? 1.2 : 1.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform.scale(
          scale: scale,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: isFirst ? 35 : 30,
              backgroundColor: Colors.white,
              child: Text(
                user["flag"],
                style: TextStyle(fontSize: isFirst ? 30 : 25),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxWidth: 100),
          child: Column(
            children: [
              Text(
                user["name"],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isFirst ? 14 : 12,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${user["points"]} GP",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: isFirst ? 13 : 11,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: isFirst ? 100 : 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                position == 1
                    ? "🥇"
                    : position == 2
                        ? "🥈"
                        : "🥉",
                style: TextStyle(fontSize: 30),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "#$position",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersList(List<Map<String, dynamic>> players) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final user = players[index];
        final isCurrentUser = user["name"] == "You";

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCurrentUser ? Color(0xFFF5F3FF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrentUser ? Colors.green : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "#${index + 4}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? Colors.green : Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrentUser ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(user["flag"]),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["name"],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCurrentUser ? Colors.green : Colors.black87,
                      ),
                    ),
                    Text(
                      "${user["points"]} GP",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isCurrentUser
                            ? Colors.green.withOpacity(0.7)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
