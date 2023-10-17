class Company {
  final String id;
  final String name;
  final String? imageUrl;

  const Company({required this.id, required this.name, this.imageUrl});

  factory Company.fromJson({required Map<String, dynamic> json}) {
    return Company(
      id: json['company_id'],
      name: json['company_name'],
      imageUrl: json['company_image_url'],
    );
  }
}
