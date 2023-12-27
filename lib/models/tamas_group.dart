import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/models/tama.dart';

class TamasGroup {
  final String? id;
  final String? name;
  final List<PlayerTama> playerTamas;

  const TamasGroup({required this.id, required this.name, this.playerTamas = const []});

  factory TamasGroup.fromJson({required Map<String, dynamic> json, List<Tama>? tamas}) {
    final playerTamas = <PlayerTama>[];
    if (tamas != null) {
      for (final tama in tamas) {
        playerTamas.add(PlayerTama.fromTama(tama: tama));
      }
    }
    return TamasGroup(id: json['tamas_group_id'], name: json['tamas_group_name'], playerTamas: playerTamas);
  }

  void addTama({required Tama tama, int numOfCompletedTricks = 0}) {
    playerTamas.add(PlayerTama.fromTama(tama: tama, completed: numOfCompletedTricks));
  }

  String get formatIdForPayment => id?.replaceAll('-', '_') ?? '';

  Map<String, dynamic> toJson() {
    return {'tamas_group_id': id, 'tamas_group_name': name};
  }

  static String revertPaymentIdToId(String id) => id.replaceAll('_', '-');
}
