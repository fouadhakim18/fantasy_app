import 'package:fantasy_app/screens/home_screen.dart';
import 'package:fantasy_app/screens/simulation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'create_name.dart';
import 'player_selection_screen.dart';
import 'leaderboard_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      MatchSimulationScreen(selectedPlayers: {}),
      CreateTeamScreen(),
      LeaderboardScreen(selectedPlayers: {}),
      CreateTeamScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        // title: "Home",
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey[400],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people_alt),
        // title: "Create Team",
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey[400],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        // title: "Simulation",
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey[400],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.leaderboard),
        // title: "Leaderboard",
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey[400],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.swap_horiz_outlined),
        // title: "Transfer Players",
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey[400],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true, 
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}
