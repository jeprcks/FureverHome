import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furever_home_admin/services/storage_service.dart';
import 'dog_event.dart';
import 'dog_state.dart';
import '../models/dog_model.dart';

class DogBloc extends Bloc<DogEvent, DogState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  DogBloc() : super(DogInitial()) {
    on<LoadDogs>((event, emit) async {
      try {
        emit(DogLoading());

        final snapshot = await _firestore.collection('dogs').get();
        final dogs = snapshot.docs
            .map((doc) => Dog.fromJson({...doc.data(), 'id': doc.id}))
            .toList();

        emit(DogsLoaded(dogs));
      } catch (e) {
        emit(DogError(
            message: e.toString())); // Changed from 'error' to 'message'
      }
    });

    on<AddDog>((event, emit) async {
      try {
        emit(DogLoading());

        String? imageUrl;
        if (event.imageFile != null) {
          imageUrl = await _storageService.uploadDogImage(
            event.imageFile!,
            event.dog.id,
          );
        }

        final dogWithImage = event.dog.copyWith(imageUrl: imageUrl);

        await _firestore
            .collection('dogs')
            .doc(event.dog.id)
            .set(dogWithImage.toJson());

        emit(DogSuccess());
      } catch (e) {
        emit(DogError(
            message: e.toString())); // Changed from 'error' to 'message'
      }
    });

    on<UpdateDog>((event, emit) async {
      try {
        emit(DogLoading());

        String? imageUrl = event.dog.imageUrl;
        if (event.imageFile != null) {
          // Delete old image if exists
          if (imageUrl != null) {
            await _storageService.deleteDogImage(event.dog.id);
          }
          // Upload new image
          imageUrl = await _storageService.uploadDogImage(
            event.imageFile!,
            event.dog.id,
          );
        }

        final dogWithImage = event.dog.copyWith(imageUrl: imageUrl);

        await _firestore
            .collection('dogs')
            .doc(event.dog.id)
            .update(dogWithImage.toJson());

        emit(DogSuccess());
      } catch (e) {
        emit(DogError(
            message: e.toString())); // Changed from 'error' to 'message'
      }
    });

    on<DeleteDog>((event, emit) async {
      try {
        emit(DogLoading());

        // Delete image from storage if exists
        await _storageService.deleteDogImage(event.dogId);

        // Delete document from Firestore
        await _firestore.collection('dogs').doc(event.dogId).delete();

        emit(DogSuccess());
      } catch (e) {
        emit(DogError(
            message: e.toString())); // Changed from 'error' to 'message'
      }
    });
  }
}
