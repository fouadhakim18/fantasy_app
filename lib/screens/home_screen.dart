import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'create_name.dart';
import 'player_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background with Dynamic Effects
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/background_stadium.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(
                              math.cos(
                                  _backgroundController.value * 2 * math.pi),
                              math.sin(
                                  _backgroundController.value * 2 * math.pi),
                            ),
                            end: Alignment(
                              -math.sin(
                                  _backgroundController.value * 2 * math.pi),
                              math.cos(
                                  _backgroundController.value * 2 * math.pi),
                            ),
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.green.withOpacity(0.3),
                              Colors.blue.withOpacity(0.3),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      // Ultra Modern Logo Section
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(
                                      0.3 + _pulseController.value * 0.2),
                                  blurRadius:
                                      30 + (_pulseController.value * 20),
                                  spreadRadius:
                                      5 + (_pulseController.value * 5),
                                ),
                                BoxShadow(
                                  color: Colors.blue.withOpacity(
                                      0.2 + _pulseController.value * 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: 'app_logo',
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/app_logo.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fade(duration: 1000.ms)
                          .scale(delay: 300.ms, duration: 800.ms),

                      SizedBox(height: 25),

                      // Enhanced Title with 3D Effect
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(0.01 * math.pi),
                        alignment: Alignment.center,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.green.shade300,
                              Colors.blue.shade300,
                              Colors.white,
                            ],
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ).createShader(bounds),
                          child: Text(
                            "Algerian Fantasy \n League",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 1000.ms)
                          .slideY(begin: 0.3, duration: 800.ms),

                      SizedBox(height: 30),

                      // Glass Morphism Tagline Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "🏆 Create your ultimate team, experience thrilling matches, and rise to legendary status!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  height: 1.6,
                                  color: Colors.white.withOpacity(0.95),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 1000.ms, delay: 200.ms)
                          .slideY(begin: 0.2, duration: 800.ms),

                      SizedBox(height: 40),

                      // Ultra Modern Feature Cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ultraModernFeatureCard(
                              Icons.people_alt,
                              "Create Team",
                              [Colors.blue.shade400, Colors.blue.shade700],
                              delay: 0,
                            ),
                            _ultraModernFeatureCard(
                              Icons.sports_soccer,
                              "Match Simulation",
                              [Colors.green.shade400, Colors.green.shade700],
                              delay: 200,
                            ),
                            _ultraModernFeatureCard(
                              Icons.leaderboard,
                              "Leaderboard",
                              [Colors.orange.shade400, Colors.orange.shade700],
                              delay: 400,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      // Floating Action Button
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTapDown: (_) => _pulseController.stop(),
                          onTapUp: (_) =>
                              _pulseController.repeat(reverse: true),
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade700,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(
                                          0.3 + _pulseController.value * 0.2),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateNameScreen()),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            size: 28,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Create Your Team",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
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
                      )
                          .animate()
                          .fade(duration: 1000.ms, delay: 600.ms)
                          .scale(delay: 600.ms, duration: 600.ms),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ultraModernFeatureCard(
      IconData icon, String label, List<Color> gradientColors,
      {required int delay}) {
    return Container(
      width: 100,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        gradientColors.map((c) => c.withOpacity(0.8)).toList(),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0]
                          .withOpacity(0.3 + _pulseController.value * 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 35,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(duration: 800.ms, delay: Duration(milliseconds: delay))
        .slideY(
            begin: 0.3, duration: 600.ms, delay: Duration(milliseconds: delay))
        .scale(delay: Duration(milliseconds: delay), duration: 600.ms);
  }
}
