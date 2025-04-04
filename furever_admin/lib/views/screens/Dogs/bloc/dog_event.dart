abstract class DogEvent {}

class AddDog extends DogEvent {
  final String name;
  final String breed;
  final String description;
  final dynamic imageFile; // Change to dynamic to handle both File and html.File

  AddDog({
    required this.name,
    required this.breed,
    required this.description,
    this.imageFile, required String size, required String gender, required Map<String, bool> medicalRecords, required String imageUrl,
  });
}

class Dog {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String size;
  final Map<String, bool> medicalRecords;
  final String imageUrl;
  final String description;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.size,
    required this.medicalRecords,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'breed': breed,
        'gender': gender,
        'size': size,
        'medicalRecords': medicalRecords,
        'imageUrl': imageUrl,
        'description': description,
      };

  factory Dog.fromJson(Map<String, dynamic> json) => Dog(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
        gender: json['gender'],
        size: json['size'],
        medicalRecords: Map<String, bool>.from(json['medicalRecords']),
        imageUrl: json['imageUrl'],
        description: json['description'],
      );
}
