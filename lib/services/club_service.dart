import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/club.dart';

class ClubService {
  static Future<List<Club>> loadClubs() async {
    String data =
        await rootBundle.loadString('assets/Algerian_fantasy_data.json');
    Map<String, dynamic> jsonResult = json.decode(data);
    List<dynamic> clubsJson = jsonResult['clubs'];
    return clubsJson.map((club) => Club.fromJson(club)).toList();
  }
}
