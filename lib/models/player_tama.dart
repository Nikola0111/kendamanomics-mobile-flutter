import 'package:kendamanomics_mobile/models/badge.dart';
import 'package:kendamanomics_mobile/models/tama.dart';

class PlayerTama {
  final Tama tama;
  final int? completedTricks;
  final BadgeType? badgeType;

  const PlayerTama({required this.tama, this.completedTricks, this.badgeType});

  factory PlayerTama.fromTama({required Tama tama, int completed = 0}) {
    return PlayerTama(
      tama: Tama(
        id: tama.id,
        name: tama.name,
        imageUrl: tama.imageUrl,
        numOfTricks: tama.numOfTricks,
        tamasGroupID: tama.tamasGroupID,
      ),
      completedTricks: completed,
    );
  }

  PlayerTama copyWith({int? completedTricks, BadgeType? badgeType}) {
    return PlayerTama(
      tama: tama,
      completedTricks: completedTricks ?? this.completedTricks,
      badgeType: badgeType ?? this.badgeType,
    );
  }
}
