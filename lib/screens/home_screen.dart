import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late AnimationController _shimmerController;

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

    _shimmerController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Enhanced Animated Background
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
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Particle Effect Overlay
                  ...List.generate(
                    20,
                    (index) => Positioned(
                      left: math.Random().nextDouble() *
                          MediaQuery.of(context).size.width,
                      top: math.Random().nextDouble() *
                          MediaQuery.of(context).size.height,
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          final offset =
                              (_shimmerController.value + index / 20) % 1.0;
                          return Transform.translate(
                            offset: Offset(
                              math.sin(offset * 2 * math.pi) * 10,
                              math.cos(offset * 2 * math.pi) * 10,
                            ),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withOpacity(0.3 * (1 - offset)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Content with Enhanced ScrollPhysics
          SafeArea(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      // Enhanced Logo Section with 3D Transform
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(0.05 * math.pi * _pulseController.value),
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
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
                                child: _buildGlassmorphicContainer(
                                  child: Image.asset(
                                    "assets/app_logo.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  borderRadius: 50,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                          .animate()
                          .fade(duration: 1000.ms)
                          .scale(delay: 300.ms, duration: 800.ms),

                      SizedBox(height: 25),

                      // Enhanced Title with Animated Gradient
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment(
                                -1.0 + (2 * _shimmerController.value),
                                0.0,
                              ),
                              end: Alignment(
                                0.0 + (2 * _shimmerController.value),
                                0.0,
                              ),
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white,
                                Colors.white.withOpacity(0.5),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(bounds),
                            child: Text(
                              "Algerian Fantasy\nLeague",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fade(duration: 1000.ms)
                          .slideY(begin: 0.3, duration: 800.ms),

                      SizedBox(height: 30),

                      // Enhanced Tagline Card with Dynamic Gradient
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: _buildGlassmorphicContainer(
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "🏆 ",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    TextSpan(
                                      text: "Create your ultimate team,\n",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        height: 1.6,
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "experience thrilling matches,\n",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        height: 1.6,
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "and rise to legendary status!",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        height: 1.6,
                                        color: Colors.green.shade300,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          borderRadius: 20,
                        ),
                      )
                          .animate()
                          .fade(duration: 1000.ms, delay: 200.ms)
                          .slideY(begin: 0.2, duration: 800.ms),

                      SizedBox(height: 40),

                      // Enhanced Feature Cards with Interactive Hover
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildEnhancedFeatureCard(
                              Icons.people_alt,
                              "Create Team",
                              [Colors.blue.shade400, Colors.blue.shade700],
                              delay: 0,
                            ),
                            _buildEnhancedFeatureCard(
                              Icons.sports_soccer,
                              "Simulation",
                              [Colors.green.shade400, Colors.green.shade700],
                              delay: 200,
                            ),
                            _buildEnhancedFeatureCard(
                              Icons.leaderboard,
                              "Leaderboard",
                              [Colors.orange.shade400, Colors.orange.shade700],
                              delay: 400,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      // Enhanced Action Button with Animation
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: _buildEnhancedActionButton(),
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

  Widget _buildGlassmorphicContainer({
    required Widget child,
    required double borderRadius,
    EdgeInsetsGeometry padding = const EdgeInsets.all(15),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
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
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEnhancedFeatureCard(
    IconData icon,
    String label,
    List<Color> gradientColors, {
    required int delay,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: Container(
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
                          colors: gradientColors
                              .map((c) => c.withOpacity(0.8))
                              .toList(),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(
                                0.3 + _pulseController.value * 0.2),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fade(duration: 800.ms, delay: Duration(milliseconds: delay))
            .slideY(
                begin: 0.3,
                duration: 600.ms,
                delay: Duration(milliseconds: delay))
            .scale(delay: Duration(milliseconds: delay), duration: 600.ms);
      },
    );
  }

  Widget _buildEnhancedActionButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => _pulseController.stop(),
          onTapUp: (_) => _pulseController.repeat(reverse: true),
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
                      color: Colors.green
                          .withOpacity(0.3 + _pulseController.value * 0.2),
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
                      // Add button press animation
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CreateNameScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.easeInOutCubic;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Icon
                          AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _shimmerController.value * 2 * math.pi,
                                child: Icon(
                                  Icons.add_circle,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 12),
                          // Animated Text
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment(
                                  -1.0 + (2 * _shimmerController.value), 0.0),
                              end: Alignment(
                                  0.0 + (2 * _shimmerController.value), 0.0),
                              colors: [
                                Colors.white.withOpacity(0.8),
                                Colors.white,
                                Colors.white.withOpacity(0.8),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(bounds),
                            child: Text(
                              "Create Your Team",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }
}
