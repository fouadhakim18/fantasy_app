import 'package:flutter/material.dart';

import '../models/player.dart';

class TransferScreen extends StatelessWidget {
  final Map<String, List<Player?>> selectedPlayers;
  final Function(String, int, Player) onTransfer;

  TransferScreen({required this.selectedPlayers, required this.onTransfer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transfer Players")),
      body: ListView(
        children: selectedPlayers.entries.expand((entry) {
          return entry.value.asMap().entries.map((playerEntry) {
            int index = playerEntry.key;
            Player? player = playerEntry.value;
            return ListTile(
              leading: player != null
                  ? CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/${player.kitImageUrl}"),
                    )
                  : Icon(Icons.person),
              title: Text(player?.name ?? "Empty"),
              subtitle: Text(entry.key),
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz, color: Colors.blue),
                onPressed: () => onTransfer(entry.key, index, player!),
              ),
            );
          });
        }).toList(),
      ),
    );
  }
}
