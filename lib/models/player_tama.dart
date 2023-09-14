import 'package:kendamanomics_mobile/models/badge.dart';
import 'package:kendamanomics_mobile/models/tama.dart';

class PlayerTama {
  final Tama tama;
  final int? completedTricks;
  final BadgeType? badgeType;

  const PlayerTama({required this.tama, this.completedTricks, this.badgeType});

  factory PlayerTama.fromTama({required Tama tama}) {
    return PlayerTama(
      tama: Tama(
        id: tama.id,
        name: tama.name,
        imageUrl: tama.imageUrl,
        numOfTricks: tama.numOfTricks,
        tamasGroupID: tama.tamasGroupID,
      ),
    );
  }
}
