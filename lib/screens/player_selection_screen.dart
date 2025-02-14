import 'dart:convert';
import 'dart:math';

import 'package:fantasy_app/models/player.dart';
import 'package:fantasy_app/screens/glassmorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'simulation_screen.dart';

// ------------------- CreateTeamScreen -------------------
class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final double totalBudget = 100; // Initial Budget (100M DZD)
  double remainingBudget = 100; // Track remaining budget

  final Map<String, Map<String, int>> formationRequirements = {
    "4-4-2": {"GK": 1, "DF": 4, "MF": 2, "FW": 4},
    "4-3-3": {"GK": 1, "DF": 4, "MF": 3, "FW": 3},
  };

  String selectedFormation = "4-4-2";
  late Map<String, List<Player?>> selectedPlayers;

  @override
  void initState() {
    super.initState();
    _initializeSelectedPlayers();
  }

  void _initializeSelectedPlayers() {
    final req = formationRequirements[selectedFormation]!;
    selectedPlayers = {
      "GK": List<Player?>.filled(req["GK"]!, null),
      "DF": List<Player?>.filled(req["DF"]!, null),
      "MF": List<Player?>.filled(req["MF"]!, null),
      "FW": List<Player?>.filled(req["FW"]!, null),
    };
  }

  void _updateFormation(String newFormation) {
    setState(() {
      selectedFormation = newFormation;
      _initializeSelectedPlayers();
      remainingBudget = totalBudget; // Reset budget when changing formation
    });
  }

  Future<void> _selectPlayer(String position, int index) async {
    final Player? selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerSelectionScreen(position: position),
      ),
    );
    if (selected != null) {
      setState(() {
        Player? previousPlayer = selectedPlayers[position]![index];

        if (previousPlayer != null) {
          remainingBudget += previousPlayer.price;
        }

        if (remainingBudget - selected.price >= 0) {
          selectedPlayers[position]![index] = selected;
          remainingBudget -= selected.price;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Not enough budget to select ${selected.name}!")),
          );
        }
      });
    }
  }

  bool isSquadComplete() {
    for (var position in selectedPlayers.keys) {
      if (selectedPlayers[position]!.contains(null)) {
        return false;
      }
    }
    return true;
  }

  Widget _buildPositionRow(String position) {
    return SizedBox(
      height: 150, // Adjust height to fit within the screen
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(selectedPlayers[position]!.length, (index) {
            final player = selectedPlayers[position]![index];
            return GestureDetector(
              onTap: () => _selectPlayer(position, index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300), // Smooth hover animation
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 75, // Reduced card width
                height: 115, // Reduced card height
                decoration: BoxDecoration(
                  gradient: player == null
                      ? LinearGradient(
                          colors: [Colors.white, Colors.grey[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.white, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(2, 2), // Subtle shadow for depth
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: player == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 30, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            position,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Tap to select",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black38, fontSize: 10),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Player Price
                          Text(
                            "${player.price}M",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          // Player Kit Image
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.18),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/${player.kitImageUrl}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Player Name
                          Text(
                            player.name, // Only first name
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Player Club
                          Text(
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            player.club,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _startMatchSimulation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MatchSimulationScreen(selectedPlayers: selectedPlayers),
      ),
    );
  }

  Future<void> _autoFillTeam() async {
    // Load all players from the JSON
    final String jsonString =
        await rootBundle.loadString('assets/Algerian_fantasy_data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    List<Player> allPlayers = [];

    for (var club in jsonData['clubs']) {
      String clubName = club['club_name'];
      String clubImageUrl = club['kit_image_url'];
      for (var p in club['players']) {
        allPlayers.add(Player.fromJson(p, clubName, clubImageUrl));
      }
    }

    // Filter players based on position and randomly assign them to the team
    final random = Random();
    Map<String, List<Player>> positionPlayers = {
      "GK": allPlayers.where((p) => p.position == "GK").toList(),
      "DF": allPlayers.where((p) => p.position == "DF").toList(),
      "MF": allPlayers.where((p) => p.position == "MF").toList(),
      "FW": allPlayers.where((p) => p.position == "FW").toList(),
    };

    // Reset the team and budget
    setState(() {
      remainingBudget = totalBudget;
      _initializeSelectedPlayers();
    });

    // Fill the team with random players
    bool success = true; // To check if the autofill succeeded
    for (var position in selectedPlayers.keys) {
      for (int i = 0; i < selectedPlayers[position]!.length; i++) {
        // Randomly select a player for this position
        if (positionPlayers[position]!.isNotEmpty) {
          final randomPlayer = positionPlayers[position]!
              .removeAt(random.nextInt(positionPlayers[position]!.length));
          if (remainingBudget - randomPlayer.price >= 0) {
            setState(() {
              selectedPlayers[position]![i] = randomPlayer;
              remainingBudget -= randomPlayer.price;
            });
          } else {
            success = false; // Not enough budget for this random player
            break;
          }
        }
      }
      if (!success) break;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Not enough budget to auto-fill the team!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Team auto-filled successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildTopBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: GlassmorphicCard(
        child: Column(
          children: [
            // Premium Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade400.withOpacity(0.9),
                    Colors.blue.shade500.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 24,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 2.seconds, begin: 0, end: 1),
                  SizedBox(width: 12),
                  Text(
                    "Create Your Fantasy Team",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildFormationSelector(),
                  _buildBudgetDisplay(),
                  _buildAutoFillButton(),
                  // Column(children: [
                  //   // Formation Selector

                  //   // Budget Display
                  //   _buildBudgetDisplay(),
                  //   _buildAutoFillButton(),
                  // ]),

                  // Auto Fill Button
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildFormationSelector() {
    return Container(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Formation",
          //   style: GoogleFonts.poppins(
          //     color: Colors.black87,
          //     fontSize: 11,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          // SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Colors.transparent,
                child: DropdownButtonFormField<String>(
                  value: selectedFormation,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  items: formationRequirements.keys.map((formation) {
                    return DropdownMenuItem(
                      value: formation,
                      child: Text(formation),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) _updateFormation(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetDisplay() {
    return Container(
      child: Column(
        children: [
          // Text(
          //   "Budget",
          //   style: GoogleFonts.poppins(
          //     color: Colors.black87,
          //     fontSize: 11,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          // SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 17,
                ),
                SizedBox(width: 8),
                Text(
                  "${remainingBudget.toStringAsFixed(0)}M DZD",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoFillButton() {
    return Column(
      children: [
        Container(
          // height: 40,
          // padding: EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton.icon(
            onPressed: _autoFillTeam,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 11, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            icon: Icon(Icons.auto_awesome, size: 17),
            label: Text(
              "Auto Fill",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ).animate().scale(
            begin: Offset(1, 1), end: Offset(1.05, 1.05), duration: 200.ms)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            Positioned.fill(
              top: 0,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset('assets/pitch.png', fit: BoxFit.cover),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  // SizedBox(height: 8),
                  // isSquadComplete()
                  //     ? Container(
                  //         width: double.infinity,
                  //         height: 40,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             "Squad Complete ✅",
                  //             style: TextStyle(
                  //                 color: Colors.green,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       )
                  //     : SizedBox(),
                  // SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Transform.scale(
                        scale: 0.87,
                        child: Container(
                          // margin: EdgeInsets.only(top: 20),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildPositionRow("MF"),
                              _buildPositionRow("FW"),
                              _buildPositionRow("DF"),
                              _buildPositionRow("GK"),
                              // SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: isSquadComplete()
            ? FloatingActionButton.extended(
                onPressed: _startMatchSimulation,
                backgroundColor: Colors.white,
                icon: Icon(
                  Icons.sports_soccer,
                  color: Colors.green,
                ),
                label: Text(
                  "Simulate Match",
                  style: TextStyle(color: Colors.green),
                ),
              )
            : null);
  }
}

class PlayerSelectionScreen extends StatefulWidget {
  final String position;

  PlayerSelectionScreen({required this.position});

  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  List<Player> allPlayers = [];
  List<Player> filteredPlayers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlayers();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPlayers() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/Algerian_fantasy_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      List<Player> players = [];

      for (var club in jsonData['clubs']) {
        String clubName = club['club_name'];
        String clubImageUrl = club['kit_image_url'];
        for (var p in club['players']) {
          players.add(Player.fromJson(p, clubName, clubImageUrl));
        }
      }

      setState(() {
        allPlayers =
            players.where((p) => p.position == widget.position).toList();
        filteredPlayers = List.from(allPlayers);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
      print('Error loading players: $e');
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredPlayers = allPlayers.where((player) {
        return player.name.toLowerCase().contains(query) ||
            player.club.toLowerCase().contains(query) ||
            player.price.toString().contains(query);
      }).toList();
    });
  }

  Color _getPositionColor() {
    switch (widget.position.toLowerCase()) {
      case 'goalkeeper':
        return Color(0xFFFF6B6B);
      case 'defender':
        return Color(0xFF4ECDC4);
      case 'midfielder':
        return Color(0xFF45B7D1);
      case 'forward':
        return Color(0xFF96C93D);
      default:
        return Color(0xFF388E3C);
    }
  }

  String _getPositionIcon() {
    switch (widget.position.toLowerCase()) {
      case 'goalkeeper':
        return '🧤';
      case 'defender':
        return '🛡️';
      case 'midfielder':
        return '⚡';
      case 'forward':
        return '⚽';
      default:
        return '👥';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No players found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final positionColor = _getPositionColor();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: positionColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              _getPositionIcon(),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 8),
            Text(
              "Select ${widget.position}",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: positionColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search players...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: positionColor),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(positionColor),
                    ),
                  )
                : filteredPlayers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredPlayers.length,
                        itemBuilder: (context, index) {
                          final player = filteredPlayers[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () => Navigator.pop(context, player),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: positionColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            player.kitImageUrl,
                                            width: 40,
                                            height: 40,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(
                                                Icons.sports_soccer,
                                                color: positionColor,
                                                size: 30,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              player.club,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: positionColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "${player.price}M",
                                          style: GoogleFonts.poppins(
                                            color: positionColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
