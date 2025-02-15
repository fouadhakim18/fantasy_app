class Player {
  final String name;
  final String position;
  final double price;
  final String club;
  final String kitImageUrl; // Club Kit Image URL
  int points = 0;
  Player({
    required this.name,
    required this.position,
    required this.price,
    required this.club,
    required this.kitImageUrl,
  });

  factory Player.fromJson(
      Map<String, dynamic> json, String clubName, String kitUrl) {
    return Player(
      name: json['name'],
      position: json['position'],
      price: (json['price'] as num).toDouble(),
      club: clubName,
      kitImageUrl: kitUrl,
    );
  }

  void updatePoints(
      {int goals = 0,
      int assists = 0,
      bool cleanSheet = false,
      int yellowCards = 0,
      int redCards = 0}) {
    points = (goals * 5) + (assists * 3) - (yellowCards * 2) - (redCards * 5);
    if (cleanSheet && (position == "GK" || position == "DF")) {
      points += 4;
    }
  }

  void resetPoints() {
    points = 0;
  }
}
