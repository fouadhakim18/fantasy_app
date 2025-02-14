import 'package:fantasy_app/screens/player_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math' as math;

class CreateNameScreen extends StatefulWidget {
  @override
  _CreateNameScreenState createState() => _CreateNameScreenState();
}

class _CreateNameScreenState extends State<CreateNameScreen>
    with TickerProviderStateMixin {
  final TextEditingController _teamNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  bool _isSubmitting = false;

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

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Animated transition
      // await Future.delayed(Duration(milliseconds: 800));

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CreateTeamScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Parallax Background
                  Positioned.fill(
                    child: Image.asset(
                      "assets/background_stadium.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dynamic Blur Effect
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX:
                            3 + math.sin(_backgroundController.value * math.pi),
                        sigmaY:
                            3 + math.cos(_backgroundController.value * math.pi),
                      ),
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: 40),

                    // Animated Logo
                    AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(0.01 *
                                math.sin(_floatingController.value * math.pi))
                            ..rotateY(0.01 *
                                math.cos(_floatingController.value * math.pi)),
                          alignment: Alignment.center,
                          child: Container(
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
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                                    width: 120,
                                    height: 120,
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

                    SizedBox(height: 30),

                    // Title with Neon Effect
                    Stack(
                      children: [
                        Text(
                          "Create Your Team Name",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 8
                              ..color = Colors.green.withOpacity(0.1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Create Your Team Name",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.green.withOpacity(0.3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ShaderMask(
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
                            "Create Your Team Name",
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fade(duration: 1000.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    SizedBox(height: 20),

                    // Animated Subtitle
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        "Enter your team's name and embark on an epic fantasy journey! ⚽",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    )
                        .animate()
                        .fade(duration: 1000.ms, delay: 200.ms)
                        .slideY(begin: 0.2, duration: 800.ms),

                    SizedBox(height: 40),

                    // Premium Input Field
                    Form(
                      key: _formKey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: TextFormField(
                              controller: _teamNameController,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter Team Name",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                prefixIcon: Icon(
                                  Icons.sports_soccer,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a team name";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fade(duration: 1000.ms, delay: 400.ms)
                        .slideX(begin: 0.3, duration: 800.ms),

                    SizedBox(height: 40),

                    // Premium Continue Button
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 60,
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
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: MaterialButton(
                            onPressed: _submit,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  "Continue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fade(duration: 1000.ms, delay: 600.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
