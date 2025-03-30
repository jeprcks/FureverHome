import 'dart:io';
import '../models/dog_model.dart';

abstract class DogEvent {}

class LoadDogs extends DogEvent {}

class AddDog extends DogEvent {
  final Dog dog;
  final File? imageFile;

  AddDog({
    required this.dog,
    this.imageFile,
  });
}

class UpdateDog extends DogEvent {
  final Dog dog;
  final File? imageFile;

  UpdateDog({required this.dog, this.imageFile});
}

class DeleteDog extends DogEvent {
  final String dogId;
  DeleteDog({required this.dogId});
}
