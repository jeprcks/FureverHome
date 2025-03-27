import 'package:furever_home_admin/views/screens/Dogs/models/dog_model.dart';

abstract class DogState {}

class DogInitial extends DogState {}

class DogLoading extends DogState {}

class DogsLoaded extends DogState {
  final List<Dog> dogs;
  DogsLoaded(this.dogs);
}

class DogSuccess extends DogState {}

class DogError extends DogState {
  final String message;
  DogError(this.message);
}