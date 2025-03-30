class Dog {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String size;
  final String? description;
  final String? imageUrl;
  final Map<String, bool> medicalRecords;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.size,
    this.description,
    this.imageUrl,
    required this.medicalRecords,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      gender: json['gender'] as String,
      size: json['size'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      medicalRecords: Map<String, bool>.from(json['medicalRecords'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breed': breed,
      'gender': gender,
      'size': size,
      'description': description,
      'imageUrl': imageUrl,
      'medicalRecords': medicalRecords,
    };
  }

  Dog copyWith({
    String? id,
    String? name,
    String? breed,
    String? gender,
    String? size,
    String? description,
    String? imageUrl,
    Map<String, bool>? medicalRecords,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      medicalRecords: medicalRecords ?? this.medicalRecords,
    );
  }

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
