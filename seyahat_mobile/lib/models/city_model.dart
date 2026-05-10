class City {
  final int id;
  final int regionId;
  final String name;
  final String? imageUrl;

  City({
    required this.id,
    required this.regionId,
    required this.name,
    this.imageUrl,
  });

  // JSON formatındaki veriyi City nesnesine dönüştürür
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      regionId: json['regionId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}