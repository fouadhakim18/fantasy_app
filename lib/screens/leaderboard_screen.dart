import 'package:fantasy_app/screens/player_selection_screen.dart';
import 'package:fantasy_app/screens/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/player.dart';
import 'dart:ui';

class LeaderboardScreen extends StatefulWidget {
  final Map<String, List<Player?>> selectedPlayers;

  LeaderboardScreen({required this.selectedPlayers});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _calculateUserTotalPoints() {
    int totalPoints = 0;
    for (var position in widget.selectedPlayers.keys) {
      for (var player in widget.selectedPlayers[position]!) {
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
        "avatar": "assets/Club_Kits/mca_kit.png",
        "flag": "🇺🇸"
      },
      {
        "name": "Ruben Geidt",
        "points": 20,
        "avatar": "assets/Club_Kits/mco_kit.png",
        "flag": "🇩🇪"
      },
      {
        "name": "Jakob L",
        "points": 23,
        "avatar": "assets/Club_Kits/akbou_kit.png",
        "flag": "🇬🇧"
      },
      {
        "name": "Madelyn Dias",
        "points": 56,
        "avatar": "assets/Club_Kits/usb_kit.png",
        "flag": "🇮🇳"
      },
      {
        "name": "Zain Vaccaro",
        "points": 31,
        "avatar": "assets/Club_Kits/jsk_kit.png",
        "flag": "🇮🇹"
      },
      {
        "name": "You",
        "points": userPoints,
        "avatar": "assets/Club_Kits/usmk_kit.png",
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
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTeamScreen(
                    preselectedPlayers: widget.selectedPlayers,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.green],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    height: size.height * 0.425,
                    child: SingleChildScrollView(
                      child: _buildPodiumSection(users.sublist(0, 3)),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(begin: Offset(0.8, 0.8)),
                  Expanded(
                    child: Container(
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
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(delay: 200.ms),
                          Expanded(
                            child: _buildPlayersList(users.sublist(3)),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 200.ms)
                      .slideY(begin: 0.2),
                ],
              ),
            ),
          );
        },
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
              _buildPodiumPosition(topThree[1], 2, 140)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.3),
              _buildPodiumPosition(topThree[0], 1, 180)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3),
              _buildPodiumPosition(topThree[2], 3, 120)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.3),
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform.scale(
              scale: scale + (isFirst ? _controller.value * 0.05 : 0),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.8 + _controller.value * 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10 + (_controller.value * 5),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: isFirst ? 35 : 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    user["avatar"],
                    width: 50,
                    height: 50,
                  ),
                  // Text(
                  //   user["flag"],
                  //   style: TextStyle(fontSize: isFirst ? 30 : 25),
                  // ),
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
                    Colors.white.withOpacity(0.3 + _controller.value * 0.1),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 1 + (_controller.value * 0.1),
                    child: Text(
                      position == 1
                          ? "🥇"
                          : position == 2
                              ? "🥈"
                              : "🥉",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.2 + _controller.value * 0.1),
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
      },
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
                  child: Image.asset(
                    user["avatar"],
                    width: 40,
                    height: 40,
                  ),
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
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * index))
            .slideX(begin: 0.2, end: 0);
      },
    );
  }
}
