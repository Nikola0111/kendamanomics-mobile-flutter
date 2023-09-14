class Trick {
  final String? id;
  final String? name;
  final String? trickTutorialUrl;

  const Trick({required this.id, required this.name, required this.trickTutorialUrl});

  factory Trick.fromJson({required Map<String, dynamic> json}) {
    return Trick(
      id: json['trick_id'],
      name: json['trick_name'],
      trickTutorialUrl: json['trick_url'],
    );
  }
}
