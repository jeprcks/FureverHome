import 'package:furever_home_admin/views/screens/Dogs/models/dog_model.dart';

abstract class DogEvent {}

class LoadDogs extends DogEvent {}

class AddDog extends DogEvent {
  final String name;
  final String breed;
  final String gender;
  final String size;
  final Map<String, bool> medicalRecords;
  final String? imageUrl;
  final String description;

  AddDog({
    required this.name,
    required this.breed,
    required this.gender,
    required this.size,
    required this.medicalRecords,
    this.imageUrl,
    required this.description,
  });
}
