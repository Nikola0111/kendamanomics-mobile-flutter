class Company {
  final String id;
  final String name;
  final String? imageUrl;

  const Company({required this.id, required this.name, this.imageUrl});

  factory Company.fromJson({required Map<String, dynamic> json}) {
    String? imageUrl = json['company_image_url'];
    if (imageUrl != null && imageUrl.isEmpty) imageUrl = null;
    return Company(
      id: json['company_id'],
      name: json['company_name'],
      imageUrl: imageUrl,
    );
  }
}
