import 'package:flutter/material.dart';
import '../models/club.dart';

class ClubSelectionScreen extends StatelessWidget {
  final List<Club> clubs;
  final Function(Club) onClubSelected;

  ClubSelectionScreen({required this.clubs, required this.onClubSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Club"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          Club club = clubs[index];
          return GestureDetector(
            onTap: () => onClubSelected(club),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ensure your kit images are in assets/Club_Kits/
                  Expanded(
                    child: Image.asset(
                      'assets/${club.kitImageUrl}',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    club.clubName,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
