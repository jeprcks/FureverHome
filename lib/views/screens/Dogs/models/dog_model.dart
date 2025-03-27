class Dog {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String size;
  final String? imageUrl;
  final String? description;
  final Map<String, bool> medicalRecords;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.size,
    this.imageUrl,
    this.description,
    required this.medicalRecords,
  });

  factory Dog.fromMap(Map<String, dynamic> map, String id) {
    return Dog(
      id: id,
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      gender: map['gender'] ?? '',
      size: map['size'] ?? '',
      imageUrl: map['imageUrl'],
      description: map['description'],
      medicalRecords: Map<String, bool>.from(map['medicalRecords'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'gender': gender,
      'size': size,
      'imageUrl': imageUrl,
      'description': description,
      'medicalRecords': medicalRecords,
    };
  }
}
