import 'player.dart';

class Club {
  final String clubName;
  final String kitImageUrl;
  final List<Player> players;

  Club({
    required this.clubName,
    required this.kitImageUrl,
    required this.players,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    var playersJson = json['players'] as List;
    List<Player> playersList =
        playersJson.map((p) => Player.fromJson(p, json['club_name'], json['kit_image_url'])).toList();
    return Club(
      clubName: json['club_name'],
      kitImageUrl: json['kit_image_url'],
      players: playersList,
    );
  }
}
